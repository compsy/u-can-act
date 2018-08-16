class RolesUseUuid < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp' # => http://theworkaround.com/2015/06/12/using-uuids-in-rails.html#postgresql
    add_column :roles, :uuid, :uuid, default: 'uuid_generate_v4()', null: false
  end
end
