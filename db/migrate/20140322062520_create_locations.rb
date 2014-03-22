class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
    t.integer  :user_id
    t.string   :address, null: false
    t.string   :gmap_url
    t.string   :coordinates
    t.boolean  :primary, default: false, null: false
    t.timestamps
    end

    add_index :locations, :user_id, unique: false
  end
end
