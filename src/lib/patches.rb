class String
    
    def multitrim 
        self.split("\n")
            .map do
                _1.strip 
            end
            .join("\n")
    end

end