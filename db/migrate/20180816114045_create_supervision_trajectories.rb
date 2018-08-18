# frozen_string_literal: true

class CreateSupervisionTrajectories < ActiveRecord::Migration[5.0]
  def change
    create_table :supervision_trajectories do |t|
      enable_extension 'uuid-ossp' # => http://theworkaround.com/2015/06/12/using-uuids-in-rails.html#postgresql
      t.uuid :uuid, default: 'uuid_generate_v4()', null: false
      t.string :name, null: false
      t.references :protocol_for_mentor, references: :protocol, null: true
      t.references :protocol_for_student, references: :protocol, null: true
      t.timestamps
    end

    add_index :supervision_trajectories,
              %i[protocol_for_mentor_id
                 protocol_for_student_id],
              name: 'index_rs_on_protocol_for_mentor_id_and_protocol_for_student_id', unique: true
    add_index :supervision_trajectories, :name, unique: true
    add_foreign_key :supervision_trajectories, :protocols, column: :protocol_for_mentor_id
    add_foreign_key :supervision_trajectories, :protocols, column: :protocol_for_student_id
  end
end
