class AddContent1Content2ToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :content1, :string
    add_column :microposts, :content2, :string
  end
end
