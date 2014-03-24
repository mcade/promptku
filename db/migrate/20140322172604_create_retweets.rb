class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.string :name
      t.string :link_url
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps
    end
  end
end
