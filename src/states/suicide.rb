
class SuicideState < BaseState


    def run 
        suggest_it("Як ви хочете вбити свого москаля ?")
            .option("Повіситись 🧶") do 
                say "Ви залізли на стула, оділи петлю та стрибнули, хеппі енд"    
            end
            .option("Застрелитись 🔫") do 
                say "Ви взяли рушницю та пустили кулю в голову 💥"
            end
            .option("Втопитись 💦") do 
                say "Ви стрибнули з моста та покормили рибок 🐋"
            end
            .option('Відміна') do 
                switch_state MainMenuState.new
            end
            .exec()

        
        switch_state RespawnState.new
    end

end 