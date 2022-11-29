

class WalkingInTownState < BaseState 

    def players_count() 
        Character.count 
    end

    def run 
        run_sometimes do 
            say("Будьте обрежні зараз йде мобілізація 🪖")
        end

        suggest_it("Ви вийшли в місто де зараз проживає #{players_count} москалів 🌆") 
            .option("Назад додму 🏘") do 
                switch_state MainMenuState.new 
            end
            .option("Сховатись в кущах 🌴") do 
                say "В розробці"
            end
            .option("Битва з ботом") do 
                switch_state BotFightState.new(__clean_state(self))
            end
            .option("Піти в магазин 🛒") do 
                say "В розробці"
            end           
            .option("Піти в бар") do 
                say "В розробці"
            end
            .exec 

        switch_state self

    end

end
