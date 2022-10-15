

class WalkingInTownState < BaseState 
    def run 
        # run_sometimes do 
        #     switch_state FightState.new(self)
        # end

        run_sometimes do 
            say("Будьте обрежні зараз йде мобілізація 🪖")
        end

        suggest_it("Ви вийшли в місто 🌆") 
            .option("Назад додму 🏘") do 
                switch_state MainMenuState.new 
            end
            .option("Сховатись в кущах 🌴") do 
                say "В розробці"
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
