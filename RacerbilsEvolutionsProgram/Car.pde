class Car {  
  //Bil - indeholder position & hastighed & "tegning"
  PVector pos = new PVector(60, 232);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0,1);
  
  void turnCar(float turnAngle){
    acc.rotate(turnAngle);
  }
  
  void displayCar() {
    stroke(100);
    fill(100);
    ellipse(pos.x, pos.y, 10, 10);
  }
  
  
  
  void update() {
    vel.add(acc);
    pos.add(vel);
  }
  
}
