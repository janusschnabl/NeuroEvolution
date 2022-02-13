class CarSystem {
  //CarSystem - 
  //Her kan man lave en generisk alogoritme, der skaber en optimal "hjerne" til de forhåndenværende betingelser
  
  ArrayList<CarController> population  = new ArrayList<CarController>();
  ArrayList<CarController> matingPool;    // ArrayList which we will use for our "mating pool"
  int generations;             // Number of generation
  int recordHolder = 0;
  float mutationRate;  
 

  CarSystem(int populationSize, float mutationRate_) {
    for (int i=0; i<populationSize; i++) { 
      CarController controller = new CarController();
      population.add(controller);
    }
    matingPool = new ArrayList<CarController>();
    mutationRate = mutationRate_;
  }

  void updateAndDisplay() {
    //1.) Opdaterer sensorer og bilpositioner
    for (CarController controller : population) {
      controller.update();
    }

    //2.) Tegner tilsidst - så sensorer kun ser banen og ikke andre biler!
    for (CarController controller : population) {
      controller.display();
    }
  }
  

  // Calculate fitness for each creature
  void fitness() {
    for (int i = 0; i < population.size(); i++) {
      population.get(i).getFitness();
      
    }
  }

  // Generate a mating pool
  void selection() {
    // Clear the ArrayList
    matingPool.clear();

    // Calculate total fitness of whole population
    float maxFitness = getMaxFitness();

    for (int i = 0; i < population.size(); i++) {
      float fitnessNormal = map(population.get(i).getFitness(),0,maxFitness,0,1);
      int n = (int) (fitnessNormal * 100);  // Arbitrary multiplier
      for (int j = 0; j < n; j++) {
        matingPool.add(population.get(i));
      }
    }
    println(getMaxFitness()); 
    
  }

  // Making the next generation
  void reproduction() {
    population.clear();
    // Refill the population with children from the mating pool
    for (int i = 0; i < populationSize; i++) {
      // Sping the wheel of fortune to pick two parents
      int m = int(random(matingPool.size()));
      int d = int(random(matingPool.size()));
      // Pick two parents
      CarController mom = matingPool.get(m);
      CarController dad = matingPool.get(d);
      // Get their genes
      float[] momgenes1 = mom.getDNA1();
      float[] dadgenes1 = dad.getDNA1();
      float[] momgenes2 = mom.getDNA2();
      float[] dadgenes2 = dad.getDNA2();
      // Mate their genes
      float[] child1 = crossover(momgenes1,dadgenes1);
      float[] child2 = crossover(momgenes2,dadgenes2);
      // Mutate their genes
      mutate(mutationRate,child1);
      // Fill the new population with the new child
      population.add(new CarController(child1,child2));
    }
    generations++;
    println(population.size());
  }

  int getGenerations() {
    return generations;
  }

  // Find highest fintess for the population
  float getMaxFitness() {
    float record = 0;
    for (int i = 0; i < population.size(); i++) {
       if(population.get(i).getFitness() > record) {
         record = population.get(i).getFitness();
       }
    }
    return record;
  }
  
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  float[] crossover(float[] partner1, float[] partner2) {
    
    float[] child = new float[partner1.length];
    
    int crossoverInt = int(random(partner1.length));
    
    for(int i = 0; i < child.length; i++){
      if(crossoverInt < i){
       child[i] = partner1[i]; 
      }
      else{
       child[i] = partner2[i]; 
      }
    }
    float[] newGenes = child;
    return newGenes;
  }
  
  void mutate(float mutationRate, float[] child){
    for(int i = 0; i < child.length; i++) {
     if(random(1) < mutationRate){
      child[i] = random(-varians,varians); 
     }
    }
    
  }
  

  
  
}
