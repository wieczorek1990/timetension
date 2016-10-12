class CreateDifferences < ActiveRecord::Migration[5.0]
  def change
    create_table :differences do |t|
      t.references :request, foreign_key: true
      t.float :result

      t.timestamps
    end
  end
end
