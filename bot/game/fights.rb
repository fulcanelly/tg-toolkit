class Player 
    
    attr_accessor :name, :health

    def initialize(name, health)
        @name = name
        @health = health
    end


    def p_id 
        1
    end

    def name 
        "Ви"
    end

end


BODY_PARTS_NAIVE = [
    :head, :chest, :stomach, :legs 
]

class MockPlayer < Player 
    
    def initialize
        super("mock player,", 100)
    end

    def choose_atack 
        BODY_PARTS_NAIVE.sample
    end


    def choose_defense 
        BODY_PARTS_NAIVE.sample
    end
    
    def name
        "Гей" 
    end


    def p_id 
        2 
    end

end



class BodyPartProperties 

    attr_accessor :letal_chance, :health, :hit_chance 

    def initialize(letal_chance:, capacity:, hit_chance:)
        @letal_chance = letal_chance
        @capacity = capacity
        @hit_chance = hit_chance
    end

end

# BODY_PARTS = {
#     head: BodyPartProperties.new(
#         letal_chance: 60,
#         capacity: 20,
#         hit_chance: 10
#     ),
#     chest: BodyPartProperties.new(

#     ),
#     stomach:,
#     legs:
# }

class Attack 
    
end


class Defense 
    
    

end


class AttackResult 

end

class Fight
    
    def reset 
        @fight = {
            @first.p_id => OpenStruct.new({
                player: @first
                }),
            @second.p_id => OpenStruct.new({
                player: @second
            }),
        }
    end

    def initialize(one, another)
        @first = one 
        @second = another
        reset()
    end

    def feed_attack(player, attack) 
        @fight[player.p_id].attack = attack
    end

    def feed_defense(player, defense)
        @fight[player.p_id].defense = defense
    end 

    def is_timeout? 
    end

    def all_voted? 
    
    end

    def done? 
        return @fight.values()
            .map() do _1.player end
            .any? do _1.health <= 0 end
    end


    def who_won? 
    
    end

    #TODO replace with attack & defense class
    def _calculate(attacking, defending)
        OpenStruct.new({
            attacking: attacking.player,
            defending: defending.player,
            target: attacking.attack,
            success: defending.defense != attacking.attack,
            damage: 25
        })
    end

    def _apply(attack) 
        if attack.success
            attack.defending.health -= attack.damage
        end
    end


    def process
        @fight.values()
            .permutation()
            .map() do |arr|
                _calculate(*arr).tap do
                    _apply(_1)
                end
            end.tap do 
                #TODO move to another place, since it can be called more than twice 
                reset()

            end

    end

end


class Game 
    
    def get_fights_for(player)
    end

end
