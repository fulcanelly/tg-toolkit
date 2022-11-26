class BotFightHandler 
    def initialize()
    end

    def join(person)
    end

end

class MyFight 

    attr_accessor :person, :fight

    def initialize(fight, person) 
        self.fight = fight
        self.person = person
    end

    def attack(part)
    end

    def run_away 
    end

    def defend(part)
        
    end

    def process_round()
    end

    def is_done?()

    end

end






class BotFightState < BaseState
    
    def initialize(next_state)
        @next_state = next_state
    end

    def how_attack
        suggest_it("Як його бити?")
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

    def how_deffend 
        suggest_it("Що захищати ?") 
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

    #TODO cereate bpdypart class and move there

    def form_body_part(part)
        mapping = {
            head: "голову",
            chest: "груди", 
            stomach: "живіт",
            legs: "ноги"
        } 

        return mapping[part] || '<<IDK>>'
    end 

    #TODO move to attack class
    def form_attack(attack) 
        if attack.success then 
            "#{attack.attacking.name} намагався " +
            "завдати удару #{attack.defending.name} у " +
            "#{form_body_part(attack.target)} але удар був блокований"
        else 
            "#{attack.attacking.name} завдав удару " +
            "#{attack.defending.name} у #{
                form_body_part(attack.target)
            } " +
            "наніс шкоду у #{attack.damage} хп "
        end
    end

    def format_player(player)
        "#{player.name} (#{player.health} / 100)"  
    end


    attr_accessor :fight, :me, :against, :counter

    def run_away 
        @done = true
        say "Ви успiшно втекли"
        
    end

    def send_summary(round_result, number)
        attack_str = round_result
            .map do form_attack _1 end
            .join("\n\n")

        say("⚔️ Хід завершений! (#{number})

            #{attack_str} 

            #{format_player(me)}
            #{format_player(against)}"
                .multitrim
        )
    end


    def process_round 
        self.counter += 1

        #deside how to attack
        attack = how_attack()
        
        return run_away() unless attack 
        fight.feed_attack(me, attack)

        #deside how to deffend
        deffend = how_deffend()

        return run_away() unless deffend 
        fight.feed_defense(me, deffend)

        #bot turn 
        fight.feed_attack(against, BODY_PARTS_NAIVE.sample) 
        fight.feed_defense(against, BODY_PARTS_NAIVE.sample) 

        #getting result
        round_result = fight.process()
        send_summary(round_result, counter)
        
    end

    def fight_done? 
        fight.done? or @done 
    end

    def run 
        say "На вас напав гей ⚔️"

        self.me = Player.new("me", 100)
        self.against = MockPlayer.new() 
        self.fight = Fight.new(me, against)
        self.counter = 0

        until fight_done? 
            process_round()
        end

        #TODO
        say "Хм"

        switch_state @next_state
    end

end


class RealFight < BaseState
    def run 
        figter = find_fighter() 
        
    end

end

