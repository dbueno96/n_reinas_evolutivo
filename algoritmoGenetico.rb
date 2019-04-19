require 'rubygems'
require 'bundler/setup'
load 'cromosoma.rb'

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


  def evaluarCromosoma(n)
    cromosoma = Cromosoma.new(n)
    arrayCromoMutate = cromosoma.mutar()

    rightDia = [n]
    leftDia = [n]
    numberRpeatsRight = Array.new(n*2, 0)
    numberRpeatsLeft = Array.new(n*2, 0)
    rightTable = Array.new(n*2, "")
    leftTable = Array.new(n*2, "")

    i=0
    queensAttack =0
    
    while i < n do
      rightMoment = i - arrayCromoMutate[i] + arrayCromoMutate.length - 1 
      rightDia.push(rightMoment)  #Right diags
      numberRpeatsRight[rightMoment] = numberRpeatsRight[rightMoment] + 1

      leftMoment= i + arrayCromoMutate[i] 
      leftDia.push(leftMoment)  #left diags
      numberRpeatsLeft[leftMoment] = numberRpeatsLeft[leftMoment] + 1

      i+=1
    end

    i=0
    while i < n do
      rightMoment = i - arrayCromoMutate[i] + arrayCromoMutate.length - 1 
      leftMoment= i + arrayCromoMutate[i]

      if numberRpeatsRight[rightMoment] > 1 or numberRpeatsLeft[leftMoment] > 1
        queensAttack+=1
      end
      i+=1
    end

    print queensAttack
    
    print "#{rightDia} \n"
    print "#{leftDia} \n"
    
    print "#{numberRpeatsRight} \n"
    print "#{numberRpeatsLeft} \n"

    print "#{rightTable} \n"
    print "#{leftTable} \n"

    return queensAttack

  end

  


end

############################################################
# 
############################################################
begin

cromosoma = Cromosoma.new(10)
algoritmo = Algoritmo_Genetico_Para_NReinas.new(8,8)
algoritmo.evaluarCromosoma(10)
end
