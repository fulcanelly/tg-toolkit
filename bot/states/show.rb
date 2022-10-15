#TODO: implement stats showing state

#TODO: add stats builder
class StatsShowingState < BaseState
    
    def run 
        say "В розробці"
        # say(
        #     "Вашого москаля зовуть  #{}"
        #     "Карма вашого москаля #{3}\n" + 
        #     "Вік вашого москаля: #{2}\n" +
        #     "Ваш москаль помер  #{1}\n" 
        # )

        switch_state MainMenuState.new 
    end

end