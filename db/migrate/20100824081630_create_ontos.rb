class CreateOntos < ActiveRecord::Migration
  def self.up
    create_table :ontos do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ontos
  end
end
