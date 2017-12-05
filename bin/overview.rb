#!/usr/bin/env ruby
#
completed_total = Response.completed

final = Organization.all.map do |org| 
  res = org.roles.map do |role|
    res_for_role = role.people.reduce(Hash.new(0)) do |tot_for_role, person|
      cur = person.protocol_subscriptions.map do |sub|
        past_week = sub.responses.in_week
        compl = past_week.completed.count
        fut = sub.responses.future.count
        {completed: compl, future: fut, total: past_week.count}
      end
      tot_for_role[:completed] = cur[:completed]
      tot_for_role[:future] = cur[:future]
      tot_for_role[:total] = cur[:total]
      tot_for_role
    end
    {role.title => res_for_role}
  end
  {org.name => res}
end

Response.first.protocol_subscription.person.role.organization


# Response.rb
#
self.in_week(week_number = nil, year = nil) do
  # According to
  # https://stackoverflow.com/questions/13075617/rails-3-2-8-how-do-i-get-the-week-number-from-rails,
  # using %U is bad, hence week_number = Time.zone.now.strftime('%U') is wrong.
  # instead, use the Date.cweek function
  week_number = Time.zone.now.to_date.cweek if week_number.nil?
  year  = Time.zone.now.year if year = nil
  date = Date.commercial(year, week_number, 1)
  where(
    'open_from <= :end_of_week AND open_from > :start_of_week',
    start_of_week: date.beginning_of_week
    end_of_week: date.end_of_week
  )
end

