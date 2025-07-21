# Response Scheduling

This document provides a detailed explanation of how the system schedules responses for protocol subscriptions and how various measurement settings influence this process.

## Overview

All response scheduling is driven by the `RescheduleResponses` use case (`app/use_cases/reschedule_responses.rb`). When invoked, it:

1. Returns early if the protocol is a restricted OTR protocol (`protocol.restricted_otr_protocol?`).
2. Opens a database transaction.
3. Deletes any future incomplete responses for the subscription (`responses.not_completed.after_date(future).destroy_all`).
4. Iterates through each measurement in the protocol and schedules new responses.

## Scheduling Flow

### 1. Cleanup of Existing Responses
Inside a single transaction, the scheduler removes any responses that have not been completed and whose `open_from` timestamp is on or after the `future` cutoff:

```ruby
protocol_subscription.responses
  .not_completed
  .after_date(future)
  .destroy_all
```

### 2. Computing Response Times
For each measurement, the scheduler calls:

```ruby
measurement.response_times(
  protocol_subscription.start_date,
  protocol_subscription.end_date,
  protocol_subscription.open_from_day_uses_start_date_offset
)
```

This method returns an array of timestamps at which new responses should open:

#### a. OTR Protocols
If the measurement belongs to an OTR protocol (`protocol.otr_protocol?`), the method returns a single timestamp (`1.minute.ago`) since one-time responses are always immediately available.

#### b. Periodical Measurements
If `measurement.period` is set, the system generates a series of timestamps starting from `open_from` and increments by `period` until the `end_date` or until `Measurement::MAX_RESPONSES` (500) is reached.

#### c. Non-Periodical Measurements
- If `measurement.offset_till_end` is present, a single timestamp is computed as `end_date - offset_till_end`.
- Otherwise, a single timestamp is computed via `open_from(start_date, open_from_day_uses_start_date_offset)`, which:
  - Adds `open_from_offset` to the `start_date`.
  - Applies `open_from_day` logic if `open_from_day` is set (adjusts to the next specified weekday).
  - Optionally respects `open_from_day_uses_start_date_offset`.

### 3. Filtering and Creation
Each computed `time` is filtered and optionally created:

- **Past Filtering**: Times older than the `future` cutoff are skipped.
- **Conditional Scheduling**: A response is only created if `measurement_requires_scheduling?` is `true`. This method returns `true` when:
  - The measurement is periodical, or
  - The protocol is an OTR protocol, or
  - There is no existing completed response for that measurement.

New responses are persisted with:

```ruby
Response.create(
  protocol_subscription_id: protocol_subscription.id,
  measurement_id: measurement.id,
  open_from: time
)
```

## Key Measurement Settings

- **period**: Interval (in seconds) between repeated responses for periodical measurements.
- **offset_till_end**: Seconds before `end_date` when a single non-periodical response should open.
- **open_from_offset**: Seconds after the subscription `start_date` when a one-off response becomes available.
- **open_from_day**: A weekday (e.g., "monday") that anchors the scheduled response.
- **open_from_day_uses_start_date_offset**: If `true`, combines the seconds since midnight of `start_date` with `open_from_offset`.
- **MAX_RESPONSES**: Maximum number of responses generated for periodical measurements (500).

## Other Measurement Settings

The following settings do not influence scheduling times directly but affect user interaction and notification behaviors:

- **open_duration**: Duration (in seconds) that the questionnaire remains open.
- **reminder_delay**: Delay (in seconds) before sending a reminder.
- **should_invite**: Whether to send an invitation when the response opens.
- **collapse_duplicates**, **only_redirect_if_nothing_else_ready**, **prefilled**, **redirect_url**: Control UI/redirect behaviors and pre-filling.

## Restricted OTR Protocols

Protocols marked as restricted OTR (`protocol.restricted_otr_protocol?` returns `true`) skip the entire scheduling process. No responses are cleaned up or created.

## Transactional Integrity

Cleanup and scheduling occur within a single database transaction to ensure atomicity—either all stale responses are removed and new ones scheduled, or none of the changes are applied on error.
