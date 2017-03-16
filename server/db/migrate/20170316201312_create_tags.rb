class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.references :audio
      t.string :name
    end
  end
end
