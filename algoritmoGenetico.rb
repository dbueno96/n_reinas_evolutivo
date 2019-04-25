require 'rubygems'
require 'bundler/setup'
load 'cromosoma.rb'

class Algoritmo_Genetico_Para_NReinas
  attr_accessor :poblacion, :myaptitudes, :prom
  def initialize(numReinas, numCromosomas)
    @poblacion = Array.new(numCromosomas)
    @myaptitudes= []
    @prom = []
    for i in (0..numCromosomas-1)
      @poblacion[i] = Cromosoma.new(numReinas)
    end

  end



  def execute( seleccion, reemplazo,generaciones, ktimes) #Probar este método porque solo lo hice y no lo probe
    evaluateAllChromosomes()  
    puts "generaciones #{generaciones}"
    puts "ktimes #{ktimes}"
    generaciones.times do |i|
      #Evaluate 
      best = bestAptitud()
      if best[0] == 0
        print "promedio de mejores aptitudes: #{@myaptitudes.reduce(:+).fdiv(@myaptitudes.size)}\n"
        print "promedio de aptitudes: #{@prom.reduce(:+).fdiv(@prom.size)}\n"
        puts "genaración #{i}"
        return bestAptitud()[1]
        break
      end

      #Selection
      indexSelection = []

      if seleccion==1
        indexSelection = torneo(ktimes)
      elsif seleccion==2
        indexSelection =  samplingSelection(ktimes)
      elsif seleccion==3
          indexSelection = rouletteSelection(ktimes)
      end
      
      arraySelection =[]
      indexSelection.each do |i|
        arraySelection.push(@poblacion[i])
      end
      #Reproduction
      arraySelection.each do |cromo|
        cromo.mutar
      end
      
      #Replace
      ##arraySelection CORRESPONDE A LOS HIJOS EN ESTE MOMENTO PORQUE YA MUTÓ
      if reemplazo == 1
        reemplazoInmediato(indexSelection, arraySelection) 
      elsif reemplazo == 2
        reemplazoInsercion(indexSelection, arraySelection) 
      end

      
    end

      
    ##RETORNA EL INDEX DEL CROMOSOMA CON MEJOR APTITUD
    print "promedio de mejores aptitudes: #{@myaptitudes.reduce(:+).fdiv(@myaptitudes.size)}\n"
    print "promedio de aptitudes: #{@prom.reduce(:+).fdiv(@prom.size)}\n"
    return bestAptitud()[1]
    
  end



  def reemplazoInmediato(selected, hijos)
    
    # @poblacion.each do |cromo|
    #   print "#{cromo.alelo}\n"
    # end

    @poblacion.reject!.each_with_index{|e, i| selected.include? i }
    #puts "removed"
    # @poblacion.each do |cromo|
    #   print "#{cromo.alelo}\n"
    # end

    @poblacion.concat(hijos)
    

  end

  def reemplazoInsercion(selected, hijos)
    
    ##ORGANIZAR ARREGLO DE MANERA CRECIENTE EN APTITUD
    @poblacion.sort!{|a,b| b.aptitud <=> a.aptitud } 
    # @poblacion.each_with_index do |cromo, i| 
    #   puts "#{i}: #{cromo.aptitud }"
    # end
  
  @poblacion = @poblacion.slice(selected.length..@poblacion.length)
  @poblacion.concat(hijos)
  @poblacion.shuffle
  end

  def worstAptitudIndexes(halfKTimes) #Probar este método
    worstPopu = [halfKTimes]
    worstPopulation = @poblacion.sort_by {|x| x.aptitud}

    for i in (0...halfKTimes-1)
      worstPopu[i].initIndex = worstPopulation[i]
    end

    return worstPopu
  end



  
  def bestAptitud() #Probar este método
    bestApti = @poblacion[0].aptitud*-1
    index = 0

    for i in (0...@poblacion.length-1)
      if @poblacion[i].aptitud*-1 < bestApti
        bestApti = @poblacion[i].aptitud*-1
        index = i
      end
    
    end
    @myaptitudes.push(bestApti)
    mean = 0
    @poblacion.each do |c|
      mean += c.aptitud
    end
    @prom.push( (mean.to_f/@poblacion.length).round(3))
    return bestApti, i

  end



  def auxSamplingSelection()
    n = @poblacion.length
    

    ##SE SUMAN LAS APTITUD DE CADA UNO DE LOS CROMOSOMAS DE LA POBLACIÓN
    summationUi = 0
    @poblacion.each do |cromo|
      summationUi -= cromo.aptitud
    end
   # puts "Suma aptitudes: #{summationUi} "
    

    #SE CALCULA LA PROBABILIDAD A CADA CROMOSOMA DE LA FORMA
    ## aptitud/suma Y SE ALMACENA EN CADA POSICIÓN probability
    probability = Array.new(n)
    @poblacion.each_with_index do |cromo, i|
      plty = -cromo.aptitud.to_f/summationUi
      probability[i] = plty.round(6)
      
    end
   # print "Probability: #{probability} \n"
    ##SE CALCULAR LAS PROBABILIDADES ACUMULADAS DE probability 
    ## Y SE ALMACENA EN LAS POSICIONES DE qiscores
    qiScores =probability
    qiScores.each_with_index do |prob, i|
      if i !=0
        qiScores[i] += qiScores[i-1]
      end    
    end
   # print "QiScores #{qiScores}\n"

    return qiScores.unshift(0) ##SE AGREGA 0 COMO PRIMER ELEMENTO 

  end



  def samplingSelection(kSelect)
    selectedIndexes = Array.new(kSelect) #ARREGLO QUE ALMACENA ÍNDICES DE CROMOSOMAS SELECCIONADOS
    qiScores = auxSamplingSelection()
    n = (qiScores.length) -1 

    #for i in (0..kSelect-1)
    (kSelect).times do |i|
      compRand =rand().round(4)# qiScores[indexGuaranted]
      indexGen = nil
      #puts "CompRand #{compRand}"
      #for j in (0..n-2)HASTA AQUÍ SI ALGO
      (n).times do |j|
        
        if ((qiScores[j] < compRand) && (compRand <= qiScores[j+1]))
            #print "#{j} "
            indexGen = j
            selectedIndexes[i] = indexGen
        end

      end

    end
    ##SE RETORNA EL ARREGLO CON INDICES SELECCIONADOS
    ##NO SE TOMAN EN CUENTA VALORES REPETIDOS NI NULOS
    return selectedIndexes.uniq.compact 
  
  end



  def rouletteSelection(kselect)
    n = @poblacion.length
    summationUi = 0
    selectedIndexes = []
    kselect.times do
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
    selectedIndexes.push(i)
    return selectedIndexes.uniq.compact

  end

  def torneo (kselect)
    selectedIndexed = []
    (kselect).times do |i|
      torneo = []## indices seleccionados para torneo
      aptitudes=[] ## aptitudes de cromosomas en esos indices
      (1..3).each_with_index do 
        rand_index = rand(@poblacion.length)
        if not torneo.include? rand_index
          torneo.push(rand_index)
          aptitudes.push(-@poblacion[rand_index].aptitud)
        end
    
      end 
      #print "torneo: #{torneo} aptitudes #{aptitudes}\n"
      

     # puts aptitudes.index(aptitudes.max)
      selectedIndexed.push(aptitudes.index(aptitudes.max))
    end

    return selectedIndexed.uniq.compact
  end
  

      
        
          

  def tournamentSelection(kSelection) #Funtion for select cromosomes taking 3 rand, k times
    selectedIndexes = Array.new(kSelection) #ARREGLO QUE ALMACENA LOS ÍNDICES DE CROMOSOMAS SELECCIONADOS
    n = @poblacion.length

    #for i in (1..kSelection) #For in k times
    (kSelection).times do |i|
      indexGenInitial = rand(n-1) #Index initial of a chromosome that will be compare according aptitude
      bestAptitud = -@poblacion[indexGenInitial].aptitud #Variable that contain the best aptitud
      puts "Inicial: #{indexGenInitial}"
      puts "Best Apt: #{bestAptitud}"
      
      #for j in (1..2)
      (1..2).each do |j| 
        indexGen = rand(n-1) #Rand number for choosen the cromosome
        if -@poblacion[indexGen].aptitud < bestAptitud #Choosing the best aptitud
           #print ": index trying \n"
          bestAptitud = @poblacion[indexGen].aptitud
          indexGenInitial = indexGen
        end
      end

      selectedIndexes[i] = indexGenInitial

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



  def evaluateIndividualChromosome(chromo) #Find the aptitud for every chromosome
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

    # puts queensAttack
    # print "Cromosoma: #{arrayCromo}\n"
    # print "Right D: #{rightDia} \n"
    # print "Left  D: #{leftDia}\n"
    
    
    # print "Repeats R: #{numberRpeatsRight} \n"
    # print "Repeats L: #{numberRpeatsLeft} \n\n"

    return queensAttack

  end


end

#############################################################################################
#Execution of the program

begin

# cromosoma = Cromosoma.new(10)
# algoritmo = Algoritmo_Genetico_Para_NReinas.new(5,16)
# puts "inicial"
# algoritmo.poblacion.each do |c|
#   print "#{c.alelo}\n"
# end
# algoritmo.execute(seleccion=2,reemplazo=2,generaciones =15000  )
# puts "final"
# algoritmo.poblacion.each do |c|
#   print "#{c.alelo}\n"
# end

individualSize =0
while individualSize ==0
  puts "Indique el tamaño de cada individuo (Tablero)"
  individualSize = gets.chomp.to_i
  if individualSize<= 0 
    puts "Solo se permiten números positivos"
    individualSize=0
  end
  print "\n"
end

population = 0
while population == 0 
  puts "Indique el número de individuos de la población"
  population = gets.chomp.to_i
  if population<=0
    puts "Solo se permiten números positivos"
    population=0
  end
  print "\n"
end

generations = 0
while generations == 0
  puts "Indique el número de iteraciones a realizar \n"
  generations = gets.chomp.to_i
  if generations<=0
    puts "Solo se permiten números positivos"
    generations=0
  end
  print "\n"
end

selectionMethod =0 
while selectionMethod == 0 
  puts "Indique el número del método de selección deseado"
  puts "1. Selección por Sorteo"
  puts "2. Selección por Torneo"
  puts "3. Selección por Ruleta"
  selectionMethod = gets.chomp.to_i
  if not (1..3).include? selectionMethod
    puts "Opción no válida. Escoja solo una de las opciones indicadas."
    selectionMethod =0
  end
  print "\n"
end

insertMethod = 0
while insertMethod == 0
  puts "Indique el número del método de inserción deseado"
  puts "1. Reemplazo Inmediato"
  puts "2. Remplazo por Inserción"
  insertMethod = gets.chomp.to_i
  if not (1..2).include? selectionMethod
    puts "Opción no válida. Escoja solo una de las opciones indicadas."
    insertMethod =0
  end
  print "\n"
end



poolSize =0
while poolSize== 0
  puts "Indique el número máximo de individuos seleccionados por generación"
  poolSize= gets.chomp.to_i
  if poolSize<=0
    puts "Solo se permiten números positivos"
  end
  if population< poolSize  
    puts"La cantidad de individuos seleccionados no debe ser mayor al total de la población"
    poolSize = 0
  end
  print "\n"
end

puts "Número de Generaciones: #{generations}"
puts "Tamaño Cromosoma: #{individualSize} Tamaño Población: #{population}"
puts "Seleccionados por generacion: #{poolSize}"
if selectionMethod== 1
  puts "Método de Selección: Sorteo"
elsif selectionMethod==2 
  puts "Método de Selección: Torneo"
elsif selectionMethod==3
  puts "Método de Selecció: Ruleta"
end

if insertMethod==1 
  puts "Método de Reemplazo: Inmmediato"
elsif insertMethod==2
  puts "Método de Reemplazo: Inserción"
end
print "\n"

algoritmo = Algoritmo_Genetico_Para_NReinas.new(5,16)
algoritmo.execute(selectionMethod, insertMethod,generations, poolSize=10)




# algoritmo.evaluateAllChromosomes()
# algoritmo.reemplazoInsercion([1,3], [])
# prueba = algoritmo.torneo(3)
# print "#{prueba}\n"
# ejemplo = algoritmo.auxSamplingSelection()
# print ejemplo
#  ejmploSeleccionSam = algoritmo.SamplingSelection(2)
#  print "#{ejmploSeleccionSam}\n"
# hola = @poblacion.aptitud.sort
# print hola

end
