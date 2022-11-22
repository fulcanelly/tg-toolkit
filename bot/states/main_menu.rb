
class MainMenuState < BaseState 

    def moscal_in_home_text 
        "Ваш москаль лежить дома 🏘"
    end

    def run         
        suggest_it(self.moscal_in_home_text)
            .option("Показати мого москаля") do 
                switch_state StatsShowingState.new() 
            end
            .option("Покормити москаля 🍴") do 
                say "Ви покормили москаля 🍽 \n\nНащо їжу на таке переводити..."
            end
            .option("Вийти на вулицю 🌆") do 
                switch_state WalkingInTownState.new
            end
            .option("Померти ☠️") do 
                switch_state SuicideState.new 
            end
            .exec
        
        switch_state self

    end

end

