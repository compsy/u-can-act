# frozen_string_literal: true

traj_name = 'Normaal begeleidingstraject'
mentor_pr_name = 'mentoren dagboek'
student_pr_name = 'studenten'

trajectory = SupervisionTrajectory.find_by_name(traj_name)
trajectory ||= SupervisionTrajectory.new(name: traj_name)
trajectory.protocol_for_mentor = Protocol.find_by_name(mentor_pr_name)
trajectory.protocol_for_student = Protocol.find_by_name(student_pr_name)
trajectory.save!
