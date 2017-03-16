class CreateAudios < ActiveRecord::Migration[5.0]
  def change
    create_table :audios do |t|
      t.string :source
      t.string :embed_code
      t.timestamps
    end
  end
end
