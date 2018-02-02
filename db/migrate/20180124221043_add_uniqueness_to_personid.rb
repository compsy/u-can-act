class AddUniquenessToPersonid < ActiveRecord::Migration[5.0]
  def change
    add_index :protocol_subscriptions, [:person_id, :filling_out_for_id], name: 'index_rs_on_person_id_and_filling_out_for_id', unique: true, where: "state = '#{ProtocolSubscription::ACTIVE_STATE}' AND person_id <> filling_out_for_id"
  end
end
