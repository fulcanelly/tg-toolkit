
class CharacterGenerationState < BaseState 

    def _gen_age() 
        rand 18..40
    end

    def _gen_occupation()
        [
            :student,
            :military,
            :worker,
            :unemployed
        ].sample
    end

    def _gen_location() 
        [
            :city,
            :willage,
            :west 
        ].sample
    end


    def run() 

        say "Придумайте iм'я вашому москалю"
        name = expect_text 
        
        sex = _suggest("Оберіть стать москаля", ["Чоловіча", "Жіноча"])
 
        say "Генеруємо вік москаля..."
        age = _gen_age()

        say "Генеруємо род діяльності та інше..."
        occupation = _gen_occupation()
        location = _gen_location()


        say(
            "Готово!\n\n" + 
            "Вашого москаля звати #{name}\n" +
            "Йому #{age} років, (sex:#{sex}) \n\n" +
            "Проживає в #{location}"
        )

        switch_state MainMenuState.new 

    end
     
end