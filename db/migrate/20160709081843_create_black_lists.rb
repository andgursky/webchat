class CreateBlackLists < ActiveRecord::Migration
  def change
    create_table :black_lists do |t|
      t.references :client, index: true
      t.timestamps
    end
  end
end
