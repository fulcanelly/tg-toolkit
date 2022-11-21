class User < ActiveRecord::Base
    has_one :character
    has_one :state

    has_many :actions

    accepts_nested_attributes_for :character, :state, :actions
end


class State < ActiveRecord::Base
    belongs_to :user 
end

class Action < ActiveRecord::Base
    belongs_to :user
end


class Character < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    belongs_to :occupation

    accepts_nested_attributes_for :user
end


class Location < ActiveRecord::Base
    has_many :characters 
    
end

class Occupation < ActiveRecord::Base
    has_many :characters
end
