class Cromosoma
    
    attr_accessor :alelo, :aptitud
    attr_accessor :tamano

    def initialize(num)
        @aptitud = -100
        @alelo = Array.new(num,num)
        @tamano = num.to_f
        i=0
        while i <num do 
            gen= rand(num)
            unless @alelo.include?(gen) 
                @alelo[i] = gen
                i +=1 
            end
        end
        @alelo.each_with_index do |variable, index| 
            #puts ("el valor en la posición #{index} es: #{variable}")
        end
    end

    

    def mutar ##Mutación por intercambio de dos posiciones del arreglo
    
        print "#{@alelo} \n"
        pos1 = rand()
        pos2 = rand()
        @alelo[(pos1*tamano).to_i], @alelo[(pos2*tamano).to_i] = @alelo[(pos2*tamano).to_i],
                                                                 @alelo[(pos1*tamano).to_i]
        
        puts "mutado"
        print "#{@alelo} \n"
        

        
        arrayAl = @alelo

        return @alelo
    end


    def cruzar (cromo) 
        #FALTA ANALIZAR EL CASO EN EL QUE EL RAND DA 0 O EL TAMAÑO DEL TABLERO
        pos = rand() 
        print @alelo 
        print "\n"
        print cromo.alelo
        print "\n"
        
        head1 = self.alelo.slice(0, pos*tamano)
        tail1 = self.alelo.slice(pos*tamano , self.tamano)

        head2 =cromo.alelo.slice(0, pos*tamano)
        tail2 = cromo.alelo.slice(pos*tamano, cromo.alelo.length)

        self.alelo= head1 +tail2
        cromo= head2 + tail1
     
        puts "cruzados"
        print @alelo 
        print "\n"
        print cromo
        print "\n"

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
cro2 = Cromosoma.new(5)
cro.cruzar(cro2)