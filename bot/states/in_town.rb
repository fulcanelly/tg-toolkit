

class WalkingInTownState < BaseState 
    def run 

        run_sometimes do 
            say("Будьте обрежні зараз йде мобілізація 🪖")
        end


        suggest_it("Ви вийшли в місто 🌆") 
            .option("Назад додму 🏘") do 
                switch_state MainMenuState.new 
            end
            .option("Hz") do 
                switch_state MainMenuState.new 
            end
            .exec 

    end

end
