
module BotFights

    BODY_PARTS = [
        :head, :chest, :stomach, :legs 
    ]

    HP_EMOJI = "❤️"

    class Attack
        attr_accessor :person, :another, :protected_part, :body_part_target, :damage

        def initialize(person, another, protected_part, body_part_target)
            @person = person
            @another = another
            @protected_part = protected_part
            @body_part_target = body_part_target
        end

        def my_turn? 
            person.is_me?
        end

        def successful? 
            return !! self.damage
        end

        def __format_body_part 
            case body_part_target
            when :head
                "у глолву"
            when :chest
                "у груди"
            when :stomach
                "в живіт"
            when :legs 
                "в ноги"
            end
        end

        def __format_my_turn 
            if successful?() then
                "💥 Вас вдарили #{__format_body_part} та нанесли шкоду у #{damage} хп "
            else
                "#{another.who} намагався вдарити вас #{__format_body_part} але удар було блоковано"
            end
        end

        def __format_bot_turn 
            if successful?() then
                "💥 Ви вдарили #{person.to_who} #{__format_body_part} та нанесли шкоду у #{damage} хп"
            else
                "Ви намагалися завдати удару #{person.to_who} #{__format_body_part} але його було блоковано"
            end
        end

        def format 
            if my_turn?() then 
                __format_my_turn
            else 
                __format_bot_turn
            end
        end

        def process
            self.person.protect(protected_part)
            self.damage = self.person.hit(body_part_target)
            self.person.reset()
        end


    end

    class BotFightRound 

        attr_accessor :number, :one, :another
        attr_accessor :attack_results 

        def initialize(number, one, another)
            self.number = number
            self.one = one 
            self.another = another
        end

        def process()
            one.process
            another.process

            self.attack_results = [one, another]

        end

        def format() 
            attacks_str = attack_results
                .map do 
                    _1.format 
                end
                .join("\n\n")
                
            fighters = [one.person, another.person]
                .map do 
                    _1.format 
                end
                .join("\n")
            
            " ⚔️ Хід завершений! (#{number})
            

            #{attacks_str}


            #{fighters}
            ".multitrim()
        end

    end

    class Fighter

        attr_accessor :hp, :protecting

        def to_who 
            throw 'todo'
        end

        def who 
            throw 'todo'
        end

        #TODO: add fight parameters contatining max fight damage etc  
        def initialize()
            self.hp = 100
        end

        # protect :: self -> BodyPart -> IO ()
        def protect(body_part) 
            self.protecting = body_part
        end

        # hit :: self -> BodyPart -> IO (NilType | Number) 
        def hit(body_part)
            throw 'unknown body part' unless BODY_PARTS.include?(body_part)
            return nil if self.protecting == body_part 
            self.hp -= 25 
            25 
            #if 
        end

        # reset :: self -> IO ()
        def reset() 
            self.protecting = nil
        end

        # is_bot? :: self -> Bool
        def is_me? 
            false
        end

        def __format_hp 
            "( #{hp} / 100 #{HP_EMOJI})" 
        end

        def format 
            "#{who} #{__format_hp}"
        end
    end

    class PoliceManFighter < Fighter 
        def to_who 
            "москальскому полісмену"
        end

        def who 
            "москальский полісмен"
        end

    end

    class PlayerFighter < Fighter

        def who 
            "Ви"
        end

        def is_me?
            true 
        end

    end

    class BotFight  

        attr_accessor :myself, :another, :run_away, :round_number

        attr_accessor :attack, :defend

        def result 
            if (another.hp <= 0) or (myself.hp <= 0)    
                { :both => true }
            elsif another.hp <= 0 
                { :bot_dead => true }
            elsif myself.hp<= 0 
                { :self_dead => true }
            elsif run_away?
                { :run_away => true }
            end
        end

        def initialize(myself, another) 
            self.myself = myself
            self.another = another
            self.round_number = 0
        end

        def run_away
            @run_away = true
        end

        def run_away?
            @run_away
        end
        
        def attack(part)
            @attack = part 
        end

        def defend(part)
            @defend = part 
        end

        def process_round()
            self.round_number += 1 

            against_me = Attack.new(myself, another, @defend, BODY_PARTS.sample) 
            against_bot = Attack.new(another, myself, BODY_PARTS.sample, @attack) 

            BotFightRound.new(round_number, against_me, against_bot).tap do 
                _1.process
            end
        end

        def is_done?()
            self.run_away? or (another.hp <= 0) or (myself.hp <= 0)   
        end

    end



    def self.start_bot_fight()  
        return BotFight.new(
            PlayerFighter.new(), PoliceManFighter.new())
    end

end

class BotFightState < BaseState
    
    def initialize(next_state)
        @next_state = next_state
    end

    def how_attack
        suggest_it("Як його бити? 🤛")
            .option("В голову") do 
                :head
            end
            .option("В груди") do 
                :chest
            end
            .option("В живіт") do 
                :stomach
            end
            .option("В ноги") do 
                :legs
            end
            .option("Втекти 🏃") do 
            
            end
            .exec()
    end

    def how_defend 
        suggest_it("Що захищати ? 🛡") 
            .option("Голову") do 
                :head
            end
            .option("Груди") do 
                :chest
            end
            .option("Живіт") do 
                :stomach
            end
            .option("Ноги") do 
                :legs
            end
            .option("Втекти 🏃") do 
            
            end
            .exec()
    end


    attr_accessor :fight

    def run_away 
        @done = true
        say "Ви успiшно втекли"
        
    end

    def process_round 
        attack = how_attack()

        return fight.run_away() unless attack 
        fight.attack(attack)

        defend = how_defend()

        return fight.run_away() unless defend 
        fight.defend(defend)

        say fight.process_round().format()
    end

    def fight_done? 
        fight.is_done? or @done 
    end

    def run 
        say "Поліцейский напав на вас  ⚔️"

        self.fight = BotFights.start_bot_fight()

        until fight.is_done?()
            process_round()
        end

        case fight.result
        in { both: } 
            switch_state RespawnState.new
        in { bot_dead: }
            
            # run_sometimes do 
            #     say "У поліцейского випав зуб, ви взяли його на пам'ять"
            # # TODO inventory 
            # end
            say "Ура, це перемога!"
            switch_state @next_state

        in { self_dead: }
            say "Ви померли в бою з полiцейским..."
            switch_state RespawnState.new 
        in { run_away: }
            switch_state @next_state
        else 
            throw 'unknown fight result'
        end


    end

end

