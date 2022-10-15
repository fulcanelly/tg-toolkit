class User < ActiveRecord::Base
    has_one :character
    has_one :state

    accepts_nested_attributes_for :character, :state
end

