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

    def try_run_away 
    end

    def defend(part)
        
    end

    def process_round()
    end

    def is_done?()

    end

end

class JoinBotFightAction < BaseAction
    
    def exec(ctx)
        #ctx.extra.
        TgSayAction.new("")   
    end
    
    def is_blocking?(ctx)
    end

end

class BotFightState < BaseState
    def initialize(next_state)
        @next_state = next_state
    end


    def find_oponent 
        
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
            " наніс шкоду у #{attack.damage} хп "
        end
    end

    def format_player(player)
        "#{player.name} (#{player.health} / 100)"  
    end


    def do_fight 
    end

    def alter_run 
        say "Шукаю опонента..."
        fight = find_oponent()
 #           .on_gey() do 132132
#            end
    end

    def try_run_away 

        say "Ви успiшно втекли"
    end


    #TODO leave fight 
    def run 
        say "На вас напав гей ⚔️"

        me = Player.new("me", 100)
        #TODO find_oponent 
        mock = MockPlayer.new() 

        fight = Fight.new(me, mock)

        until fight.done? 
            attack = how_attack()
            unless attack 
                break try_run_away()
            end

            fight.feed_attack(me, attack)

            deffend = how_deffend()
            unless attack 
                break try_run_away()
            end

            fight.feed_attack(me, deffend)

            #TODO should be kind of async
            # smth like get_round_results() 

            fight.feed_attack(mock, BODY_PARTS_NAIVE.sample) 
            fight.feed_defense(mock, BODY_PARTS_NAIVE.sample) 

            
            attack_str = fight.process()
                .map do form_attack _1 end
                .join("\n\n")

            say("#{attack_str} " +
                "\n\n" + 
                "#{format_player(me)}\n" +
                "#{format_player(mock)}\n"
            )
            
        end

        say "Хм"

        switch_state @next_state
    end

end


class RealFight < BaseState
    def run 
        figter = find_fighter() 
        
    end

end
