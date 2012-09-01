class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end

    Board.create! :title => "Random", :slug => "b"
  end
end
