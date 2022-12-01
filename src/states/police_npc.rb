
class PoliceIncidentState < BaseState
    def initialize(back)
        @back = back 
    end

    def run 
        suggest_it("👮‍♀️ До вас підійшов москальский поліцейский, питає показати документи, в руках тримає повістку")
            .option("Дати ляпаса") do 
                switch_state BotFightState.new(__clean_state(@back))
            end
            .option("Тікати") do
 
            end
            .option("Показати документи") do
                #TODO 
            end
            .exec

        switch_state @back
    end

end
