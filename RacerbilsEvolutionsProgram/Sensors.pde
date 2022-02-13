class SensorSystem {
  //SensorSystem - alle bilens sensorer - ogå dem der ikke bruges af "hjernen"
  
  //Bestemmer hvilke streger der er blevet kørt over.
  boolean redCrossed = false;
  boolean blueCrossed = false;
  boolean greenCrossed = false;
  boolean out = false;
  
  float fitness1;
  float fitness2;
  
  
  //wall detectors
  float sensorMag = 80;
  float sensorAngle = PI*2/8;
  
  PVector anchorPos           = new PVector();
  
  PVector sensorVectorFront   = new PVector(0, sensorMag);
  PVector sensorVectorLeft    = new PVector(0, sensorMag);
  PVector sensorVectorRight   = new PVector(0, sensorMag);

  boolean frontSensorSignal   = false;
  boolean leftSensorSignal    = false;
  boolean rightSensorSignal   = false;

  //crash detection
  int whiteSensorFrameCount    = 0; //udenfor banen

  //clockwise rotation detection
  PVector centerToCarVector     = new PVector();
  float   lastRotationAngle   = -1;
  float   clockWiseRotationFrameCounter  = 0;

  //lapTime calculation
  float     lapTimeInFrames       = 10000;

  void updateSensorsignals(PVector pos, PVector vel) {
    //Collision detectors
    frontSensorSignal = get(int(pos.x+sensorVectorFront.x), int(pos.y+sensorVectorFront.y))==-1?true:false;
    leftSensorSignal = get(int(pos.x+sensorVectorLeft.x), int(pos.y+sensorVectorLeft.y))==-1?true:false;
    rightSensorSignal = get(int(pos.x+sensorVectorRight.x), int(pos.y+sensorVectorRight.y))==-1?true:false;  
    //Crash detector
    color color_car_position = get(int(pos.x), int(pos.y));
    if (color_car_position ==-1) {
      whiteSensorFrameCount = whiteSensorFrameCount+1;
    }
    //Laptime calculation
    
      if (red(color_car_position)==0 && blue(color_car_position)!=0 && green(color_car_position)==0  && greenCrossed == false) {//den grønne målstreg er detekteret
      blueCrossed = true;
      fitness1 = 50;
    }
    
     if (red(color_car_position)==0 && blue(color_car_position)!=0 && green(color_car_position)==0  && greenCrossed == true && redCrossed == true){//den grønne målstreg er detekteret
      fitness1 = 300;
    }
    
     if (red(color_car_position)!=0 && blue(color_car_position)==0 && green(color_car_position)==0 && blueCrossed == true && greenCrossed == false) {//den grønne målstreg er detekteret
      redCrossed = true;
      fitness1 = 100;
    }
    
    if (red(color_car_position)==0 && blue(color_car_position)==0 && green(color_car_position)!=0 && redCrossed == true && blueCrossed == true && greenCrossed == false) {//den grønne målstreg er detekteret
      lapTimeInFrames = frameCount - lastTimeInFrames;
      greenCrossed = true;
      fitness1 = 200;
      succes++;
    }
    
    centerToCarVector.set((height/2)-pos.x, (width/2)-pos.y);    
    float currentRotationAngle =  centerToCarVector.heading();
    float deltaHeading   =  lastRotationAngle - centerToCarVector.heading();
    clockWiseRotationFrameCounter  =  deltaHeading>0 ? clockWiseRotationFrameCounter + 1 : clockWiseRotationFrameCounter -1;
    lastRotationAngle = currentRotationAngle;
    
    updateSensorVectors(vel);
    
    anchorPos.set(pos.x,pos.y);
  }

  void updateSensorVectors(PVector vel) {
    if (vel.mag()!=0) {
      sensorVectorFront.set(vel);
      sensorVectorFront.normalize();
      sensorVectorFront.mult(sensorMag);
    }
    sensorVectorLeft.set(sensorVectorFront);
    sensorVectorLeft.rotate(-sensorAngle);
    sensorVectorRight.set(sensorVectorFront);
    sensorVectorRight.rotate(sensorAngle);
  }
  
  
  float calcFitness(){
    
    fitness2 = fitness1/(lapTimeInFrames/60);
    
    fitness2 = pow(fitness2,4);
    
    if( clockWiseRotationFrameCounter > 75) {
      fitness2 *= 1.1; 
    }
    
    //Hvis ude i mindre end 1 sekund
    if(whiteSensorFrameCount < 60){
      fitness2 *= 2;
    }
    
    //Hvis ude i mere end 1 sekund
    if(whiteSensorFrameCount > 60){
      fitness2 *= 0.1;
    }
    return fitness2+1/(lapTimeInFrames/60);
  }
  
  
  
  
}
