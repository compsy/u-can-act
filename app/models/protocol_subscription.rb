# frozen_string_literal: true

class ProtocolSubscription < ApplicationRecord
  include ActiveModel::Validations
  ACTIVE_STATE = 'active'
  CANCELED_STATE = 'canceled'
  COMPLETED_STATE = 'completed'
  belongs_to :person
  belongs_to :filling_out_for, class_name: 'Person', inverse_of: false
  belongs_to :protocol
  validates :state, inclusion: { in: [ACTIVE_STATE, CANCELED_STATE, COMPLETED_STATE] }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :open_from_day_uses_start_date_offset, inclusion: [true, false]

  # NOTE: this ordering is important for a number of reasons. E.g.:
  # - Response.last? uses it to determine if this is the last in the set.
  has_many :responses, -> { order open_from: :asc }, dependent: :destroy, inverse_of: :protocol_subscription

  # These two methods used to be after_initialize callbacks, but that gave performance
  # issues because when you're serializing a bunch of protocol subscriptions and using
  # a .includes() directive to make the query more efficient. That .includes() gets ignored
  # if you have an after_initialize callback that references one of the objects in that
  # .includes().
  # This is because after_initialize is not smart enough to make use of .includes()
  # and so when it has to initialize a linked object in an after_initialize filter,
  # it does so with a query per instantiated object.
  # Moreover, because Rails then sees that the object we were trying to include is now
  # cached, it will no longer perform any nested .includes() that we may have had for
  # these objects.
  # Because there's no way to do smart db queries that use .includes() from within
  # an after_initialize filter (because by definition, the after_initialize is called
  # for every single object, not for a collection of objects), the result is that
  # the .includes() relating to the linked object and any nested objects therein
  # get ignored and will be executed will N+1 queries instead when referenced.
  # The solution we use here is to use before_validation actions instead. These actions
  # are called when validating the object, which is typically before saving the object
  # due to an update or create, rather than on every instantiation. This simple change
  # makes response times for the API easily 10 times as fast in cases of nested
  # .includes().
  # So to summarize: don't use after_initialize actions that reference other objects
  # (i.e., those that the current object is linked to through a belongs_to, has_one,
  # or has_many).
  before_validation :initialize_filling_out_for
  before_validation :initialize_end_date

  after_create :schedule_responses
  has_many :protocol_transfers, dependent: :destroy

  # Commented this to allow to start multiple mentor'ed diary studies for the SDV project.
  # validates :filling_out_for_id,
  #           uniqueness: { scope: %i[person_id state],
  #                         conditions: -> { where(state: ACTIVE_STATE) },
  #                         if: ->(sub) { sub.person_id != sub.filling_out_for_id } }
  scope :active, (-> { where(state: ACTIVE_STATE).where('end_date > :now', now: Time.zone.now) })

  def transfer!(transfer_to)
    raise('The person you transfer to should not be the same as the original person!') if transfer_to == person

    protocol_transfers << ProtocolTransfer.new(from: person, to: transfer_to, protocol_subscription_id: id)
    self.filling_out_for = transfer_to if for_myself?
    self.person = transfer_to
    save!
  end

  def stop_response
    # We can be sure there is always at most one stop response as this is forced / validated in the
    # protocol class.
    responses.joins(:measurement).find_by(measurements: { stop_measurement: true })
  end

  def active?
    state == ACTIVE_STATE && !ended?
  end

  def canceled?
    state == CANCELED_STATE
  end

  def cancel!
    update!(state: CANCELED_STATE, end_date: Time.zone.now)
    DestroyFutureResponsesJob.perform_later(id)
  end

  def ended?
    Time.zone.now > end_date
  end

  def for_myself?
    person == filling_out_for
  end

  def mentor?
    !for_myself?
  end

  def earned_euros(check_future = false)
    protocol.calculate_reward(completion, check_future) / 100.0
  end

  def protocol_completion
    on_streak = 0
    responses.map do |response|
      on_streak, current_streak = retrieve_periodical_streak(on_streak, response)

      # NOTE: in the future we might want to remove the still_possible? and future_or_current? from the serialized
      # object in favor of open_from to cut down on transfer time
      create_protocol_completion_entry(response, current_streak)
    end
  end

  def retrieve_periodical_streak(on_streak, response)
    if response.measurement.periodical?
      on_streak = determine_streak(on_streak, response.completed?, response.still_possible?)

      # Return the on_streak twice, so we update the current_streak
      return [on_streak, on_streak]
    end
    [on_streak, -1]
  end

  def needs_informed_consent?
    !(protocol.informed_consent_questionnaire.blank? ||
      informed_consent_given_at.present?)
  end

  def informed_consent_remote_content
    ResponseContent.find(informed_consent_content) if informed_consent_content.present?
  end

  def informed_consent_values
    rcontent = informed_consent_remote_content
    return rcontent&.content if rcontent&.content.nil? || rcontent&.scores.blank?

    rcontent&.content&.merge(rcontent&.scores)
  end

  def completion
    # cached version
    @completion ||= protocol_completion
  end

  def max_still_earnable_reward_points
    from = latest_streak_value_index + 1
    # Put the "now" time in a variable so Time.zone.now is not different for every response.
    now = Time.zone.now
    to = from + responses.count { |response| response.open_from > now }
    sliced_completion = completion.slice((from...to))
    protocol.calculate_reward(sliced_completion, true)
  end

  def latest_streak_value_index
    completion_index = completion.find_index { |entry| entry[:future] }
    return -1 if completion_index.nil?

    completion_index - 1
  end

  private

  def determine_streak(streak, current_response_completed, current_response_in_future)
    return streak + 1 if current_response_completed || current_response_in_future

    0
  end

  def create_protocol_completion_entry(response, streak)
    result = {}
    result[:completed] = response.completed?
    result[:periodical] = response.measurement.periodical?
    result[:reward_points] = response.measurement.reward_points
    result[:future] = response.still_possible?
    result[:streak] = streak
    result[:future_or_current] = response.future_or_current?
    result[:open_from] = response.open_from
    result[:questionnaire_key] = response.measurement.questionnaire.key

    result
  end

  def initialize_filling_out_for
    # Note that this means that if the person you're filling out the protocol subscription for
    # is destroyed, then the filling_out_for automatically gets reset back to yourself.
    self.filling_out_for ||= person
  end

  def initialize_end_date
    self.end_date ||= TimeTools.increase_by_duration(start_date, protocol.duration) if
      start_date.present? && protocol.present?
  end

  def schedule_responses
    RescheduleResponses.run!(protocol_subscription: self, future: 10.minutes.ago)
  end
end
