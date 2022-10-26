class User < ActiveRecord::Base
    has_one :character
    has_one :state

    accepts_nested_attributes_for :character, :state
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
