class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.string :ip
      t.datetime :result

      t.timestamps
    end
  end
end
