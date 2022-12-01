
class RespawnState < BaseState 
    
    def run 
        amount = (10 + random() * 10).to_i
        myself.character.tap do 
            _1.karma += amount
            _1.deaths += 1
            _1.save
        end

        say "+#{amount} карми ☯️ за хорошого руського"

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

