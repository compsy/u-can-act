class AddLocaleToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :locale, :string, default: Rails.application.config.i18n.default_locale, null: true
  end
end
