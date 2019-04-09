class Cromosoma
    
    attr_accessor :alelo, :aptitud
    attr_accessor :tamano

    def initialize(size:7, aptitud:-100)
        self.aptitud = -aptitud
        self.tamano = size
        self.alelo = Array.new (size) {rand size}
        
    end

    
    def initialize(num)
        @aptitud = -100
        @alelo = Array.new(num,num)
        
        i=0
        while i <num do 
            gen= rand(num)
            unless @alelo.include?(gen) 
                @alelo[i] = gen
                i +=1 
            end
        end
        @alelo.each_with_index do |variable, index| 
            puts ("el valor en la posición #{index} es: #{variable}")
        end
    end

    

    def mutar 
       

    end

    def cruzar (cromosoma) 
    
    end

    
    def mostrar 
        self.alelo.each do | element |
            self.tamano.times do 
                print 'o '
            end
            print "\n"
        end
    end

    def describe 
        puts "El tamaño de cromosoma es #{self.tamano}"
        puts "El alelo es #{self.alelo}"
        reinas = ""
        self.alelo.each_with_index do |element, i|
            reinas += "(#{i}, #{self.alelo[i]}) " 
            
        end
        puts "Entonces las reinas están en #{reinas} " 
    end
    
end

generator = Random.new(3) 
cro = Cromosoma.new (5)
cro.describe