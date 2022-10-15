
class RespawnState < BaseState 
    
    def run 
        #TODO : implement death count 
        suggest_it("Ваш москаль помер ⚰️\n\n Що робити ?")
            .option("Воскресити москаля") do 
                switch_state MainMenuState.new 
            end
            .option("Створити нового") do 
                switch_state CharacterGenerationState.new
            end
            .exec()
    end

end

