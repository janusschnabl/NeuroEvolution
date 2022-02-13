//populationSize: Hvor mange "controllere" der genereres, controller = bil & hjerne & sensorer
int       populationSize  = 500;     
float varians             = 2; //hvor stor er variansen på de tilfældige vægte og bias
//CarSystem: Indholder en population af "controllere" 
CarSystem carSystem       = new CarSystem(populationSize, 4);

//trackImage: RacerBanen , Vejen=sort, Udenfor=hvid, Målstreg= 100%grøn 
PImage    trackImage;
int lifetime = 1000;
int lifecycle;
float lastTimeInFrames;

void setup() {
  frameRate(60);
  size(1000, 700);
  trackImage = loadImage("track1.png");
}

void draw() {
  clear();
  fill(255);
  rect(0,50,1000,1000);
  image(trackImage,0,0);  

  
  
    if (lifecycle < lifetime) {
      carSystem.updateAndDisplay();
      lifecycle++;
    // Otherwise a new generation
  } 
  else {
    lifecycle = 0;
    carSystem.fitness();
    carSystem.selection();
    carSystem.reproduction();
    lastTimeInFrames = frameCount;
  }
  
 
  if (frameCount%1==0) {
      //println("FJERN DEM DER KØRER UDENFOR BANEN frameCount: " + frameCount);
      for (int i = carSystem.population.size()-1 ; i >= 0;  i--) {
        SensorSystem s = carSystem.population.get(i).sensorSystem;
        if(s.whiteSensorFrameCount > 0 ){
          carSystem.population.remove(carSystem.population.get(i));
         }
      }
    }
    //
}