
class CharacterGenerationState < BaseState 

    def _gen_age() 
        rand 18..40
    end

    def _gen_occupation()
        #TODO: make occupation  and location generators and then select from database

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

    def create_one(name, sex, age) 
        is_man = if (sex == "Чоловіча") then true else false end
    
        myself.character.destroy if myself.character
        myself.character = Character.new(
            name:,
            is_man?: is_man,
            age:,
            
            deaths: 0, 
            karma: -1 
        )
        myself.save
    end
    
    def run() 
        say "Придумайте iм'я вашому москалю"
        name = expect_text()
        
        sex = _suggest("Оберіть стать москаля", ["Чоловіча", "Жіноча"])
 
        say "Генеруємо вік москаля..."
        age = _gen_age()

        say "Генеруємо род діяльності та інше..."
        occupation = _gen_occupation()
        location = _gen_location()

        create_one(name, sex, age)

        say("Готово!\n\n #{myself.character}")

        switch_state MainMenuState.new 

    end
     
end