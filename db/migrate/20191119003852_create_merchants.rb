class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      enable_extension 'citext'
      t.citext :name

      t.timestamps
    end
  end
end
