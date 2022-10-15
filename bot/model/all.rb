require_relative './connect'


class CreateAll < ActiveRecord::Migration[7.0]
    def change 
        create_table :users, if_not_exists: true do |t|
                    
            t.string :name
            t.integer :user_id
            
            t.timestamps 
        end
        
        create_table :states, if_not_exists: true do |t|
            t.binary :state_dump 

            t.references :user, null: true, foreign_key: { to_table: :users }

            t.timestamps
        end

        create_table :characters, if_not_exists: true do |t|
            t.string :name
            t.integer :age
            t.integer :karma 
            t.integer :deaths

        # t.belongs_to :user
            t.references :user, null: true, foreign_key: { to_table: :users }

            t.timestamps 


        end 

    end
end


CreateAll.new.change