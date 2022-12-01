#TODO: add achivements

class StatsShowingState < BaseState

    def run 
        say " 
         Ваш москаль 👺

        #{myself.character.format}
        ".multitrim

        switch_state MainMenuState.new 
    end

end