
class CoreCreateAll < ActiveRecord::Migration[7.0]
    def change

        #telegram user
        create_table :users, if_not_exists: true do |t|

            t.string :name
            t.bigint :user_id

            t.timestamps
        end
        
        #state of bot
        create_table :states, if_not_exists: true do |t|
            t.binary :state_dump

            t.references :user, null: true, foreign_key: { to_table: :users }

            t.timestamps
        end

        # recorded action of state
        create_table :actions, if_not_exists: true do |t|
            t.references :user, foreign_key: { to_table: :users }
            t.string :name
            t.binary :data
            t.timestamps
        end

        create_table :idk, if_not_exists: true do |t|

        end if false
    end
end


