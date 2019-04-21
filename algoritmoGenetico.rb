require 'rubygems'
require 'bundler/setup'
load 'cromosoma.rb'

class Algoritmo_Genetico_Para_NReinas

  def initialize(numReinas, numCromosomas)
    
    @poblacion = Array.new(numCromosomas)

    for i in (0..numCromosomas-1)
      @poblacion[i] = Cromosoma.new(numReinas)
    end

  end


  def executeAlg(generaciones)

    #First part of the algorithm


    
  end

  def auxSamplingSelection()
    n = @poblacion.length
    summationUi = 0

    i=0
    while i<n do
      summationUi = summationUi + @poblacion[i].aptitud*-1
      i+=1
    end

    print summationUi
    print "suma \n"

    probability = Array.new(n)

    i=0
    while i<n do
      Float plty = (@poblacion[i].aptitud*-1).to_f/summationUi.to_f
      probability[i] = plty
      print plty
      print "proba \n"
      i+=1
    end
    
    print " \n"
    qiScores = Array.new(n)

    i=0
    while i<n do
      qiScore=0

      j=0
      while j<=i do
        qiScore = probability[j] + qiScore
        j+=1
      end

      qiScores[i] = qiScore

      i+=1
    end

    return qiScores

  end

  def SamplingSelection(kSelect)
    selectedIndexes = Array.new(kSelect) #Array that will contain the indexes of the selected chromosomes
    qiScores = auxSamplingSelection()
    n = qiScores.length

    for i in (0..kSelect-1)
      indexGuaranted = rand(1...n-1)
      compRand = qiScores[indexGuaranted]
      indexGen = nil
      
      for j in (0..n-2)
        if ((qiScores[j] < compRand) && (compRand <= qiScores[j+1]))
            indexGen = j+1
            selectedIndexes[i] = indexGen
        end

      end

    end

    return selectedIndexes
  
  end


  def rouletteSelection() #PArcialmente terminada

    n = @poblacion.length
    summationUi = 0

    i=0
    while i<n do
      summationUi = summationUi + @poblacion[i].aptitud*-1
      i+=1
    end

    limit = rand(summationUi)
    aux = @poblacion.aptitud[0]
    i=1

    while aux<limit do
      aux = aux + @poblacion.aptitud[i]
      i+=1
    end


  end


  def tournamentSelection(kSelection) #Funtion for select cromosomes taking 3 rand, k times
    selectedIndexes = Array.new(kSelection) #Array that will contain the indexes of the selected chromosomes
    n = @poblacion.length

    for i in (1..kSelection) #For in k times
      indexGenInitial = rand(n-1) #Index initial of a chromosome that will be compare according aptitude
      bestAptitud = @poblacion[indexGenInitial].aptitud*-1 #Variable that contain the best aptitud

      for j in (1..2) 
        indexGen = rand(n-1) #Rand number for choosen the cromosome
        if @poblacion[indexGen].aptitud*-1 < bestAptitud #Choosing the best aptitud
           #print ": index trying \n"
          bestAptitud = @poblacion[indexGen].aptitud
          indexGenInitial = indexGen
        end
      end

      selectedIndexes[i-1] = indexGenInitial

    end

    return selectedIndexes #Return the k indexes selected

  end

  def evaluateAllChromosomes() #Evaluate every chromosome of the population

    i=0
    while i < @poblacion.length do
      evaluateIndividualChromosome(@poblacion[i])
      i+=1
    end

  end

  def evaluateIndividualChromosome(chromo)
    n = chromo.tamano 
    arrayCromo= chromo.alelo

    rightDia = [n]
    leftDia = [n]
    numberRpeatsRight = Array.new(n*2, 0)
    numberRpeatsLeft = Array.new(n*2, 0)

    i=0
    queensAttack =0
    
    while i < n do
      rightMoment = i - arrayCromo[i] + arrayCromo.length - 1 

      rightDia.push(rightMoment)  #Right diags
      numberRpeatsRight[rightMoment] = numberRpeatsRight[rightMoment] + 1

      leftMoment= i + arrayCromo[i] 
      leftDia.push(leftMoment)  #left diags
      numberRpeatsLeft[leftMoment] = numberRpeatsLeft[leftMoment] + 1

      i+=1
    end

    i=0
    while i < n do
      rightMoment = i - arrayCromo[i] + arrayCromo.length - 1 
      leftMoment= i + arrayCromo[i]

      if numberRpeatsRight[rightMoment] > 1 or numberRpeatsLeft[leftMoment] > 1
        queensAttack+=1
      end
      i+=1
    end

    queensAttack = queensAttack*-1
    
    chromo.aptitud = queensAttack #Set the aptitud value of the chromosome

    print queensAttack
    
    print "#{rightDia} \n"
    print "#{leftDia} \n"
    
    print "#{numberRpeatsRight} \n"
    print "#{numberRpeatsLeft} \n"

    return queensAttack

  end


end

#############################################################################################
#Execution of the program

begin

cromosoma = Cromosoma.new(10)
algoritmo = Algoritmo_Genetico_Para_NReinas.new(6,6)
algoritmo.evaluateAllChromosomes()
prueba = algoritmo.tournamentSelection(4)
print prueba
ejemplo = algoritmo.auxSamplingSelection()
print ejemplo
ejmploSeleccionSam = algoritmo.SamplingSelection(5)
print ejmploSeleccionSam

end
