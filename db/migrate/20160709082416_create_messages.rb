class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.belongs_to :sender, :class_name => "Client"
      t.belongs_to :receiver, :class_name => "Client"
      t.timestamps
    end
  end
end
