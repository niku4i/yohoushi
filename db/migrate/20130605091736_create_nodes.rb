class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :type # STI
      t.string :path, limit: 255*3+3, null: false, collation: 'utf8_bin' # note that index works upto 255
      t.string :description
      t.boolean :visible, default: true, null: false
      t.boolean :complex

      t.timestamps
    end
  end
end
