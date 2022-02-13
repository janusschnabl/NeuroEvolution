class NeuralNetwork {
  //All weights
  float[] weights = new float[8];

  float[] biases = {0,0,0};//new float[3];
  
  NeuralNetwork(float varians){
    for(int i=0; i < weights.length -1; i++){
      weights[i] = random(-varians,varians);
    }
    for(int i=0; i < biases.length -1; i++){
      biases[i] = random(-varians,varians);
    }    
  }
  
  NeuralNetwork(float[] weights_, float[] biases_){
    weights = weights_;
    biases = biases_;
  }
  

  float getOutput(float x1, float x2, float x3) {
    float o11 = weights[0]*x1+ weights[1]*x2 + weights[2]*x3 + biases[0];
    float o12 = weights[3]*x1+ weights[4]*x2 + weights[5]*x3 + biases[1];
    return o11*weights[6] + o12*weights[7] + biases[2];
  }
}
