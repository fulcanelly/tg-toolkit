# class BaseMoscalState < BaseState
#     def me_when_smth_applied
#         if gender == :male 
#             "свого москаля"
#         else 
#             "свою москальку"
#         end
#     end

# end




class StartingState < BaseState 

    def run
        
        #just to skip /start command 
        expect_text

        say "Ласкаво просимо до нашого бота 🇺🇦"
        say "Цей бот розроблено з метою зібрати кошти на ЗСУ і дати можливість людям відчути себе більш залученими в боротьбу з москалями"
        _suggest("Адже як відомо - русофобії багато не буває", ['Почати гру'])
    

        say(
            "Ще один факт - у москалів немає свободи волі, " + 
            "тому у грі ви маєте власного москаля який повністью вам підкоряється"
        )


        switch_state CharacterGenerationState.new
    end

end