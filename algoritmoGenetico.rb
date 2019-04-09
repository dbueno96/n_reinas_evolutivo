require 'rubygems'
require 'bundler/setup'

# Programa: algoritmoGenetico.rb
# Autor: 
# Email: 
# Fecha creación: 
# Fecha última modificación: 
# Versión: 
# Tiempo dedicado: 

############################################################
# 
############################################################
class Cromosoma

  def initialize(num)

    @aptitud = 0
    @cromosoma = Array.new(num,num)
     
    i=0

    while i<num do

      gen = rand(num)

      unless @cromosoma.include?(gen)
        @cromosoma[i]=gen
        i += 1
      end
    end 

    @cromosoma.each_with_index do |variable, index|
	puts("el valor en la posición #{index} es: #{variable}")
    end

  end


  def mutar
    
  end


  def cruce
    
  end

  def asignarAptitud (aptitud)
    @aptitud = aptitud
  end

  def consultarAptitud
    @aptitud
  end
end

############################################################
# 
############################################################
class Algoritmo_Genetico_Para_NReinas

  def initialize(numReinas, numCromosomas)
    
    @poblacion = Array.new(numCromosomas)

	
    for i in (0..numCromosomas)
      @poblacion[i] = Cromosoma.new(numReinas)
      puts("")
    end
  end


  def ejecutar(generaciones)
    
  end


  def evaluarCromosoma
    
  end
end

############################################################
# 
############################################################
begin

#cromosoma = Cromosoma.new(10)
algoritmo = Algoritmo_Genetico_Para_NReinas.new(8,8)
end









=begin
ataque = 0
for i in (0..(numero-2))
	#puts (vec[i])

	for j in ((i+1)..(numero-1))
		if (i+vec[i]==j+vec[j])
			ataque += 1
		end

		if (i-vec[i]==j-vec[j])
			ataque += 1
		end
	end
end
=end



