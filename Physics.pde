

class Physics {
  float g, L, mu;
  float THETA_0 = PI / 3.0;
  float THETA_DOT_0 = 0;
  float G;
  PVector nil = new PVector(0, 0, 0);
  Physics(float g, float L, float mu, float G) {
    this.g = g;
    this.L = L; 
    this.mu = mu;
    this.G = G;
    
  }
  
  
  
  PVector gBetween(Planet a, Planet b) {
     
    
     PVector atob = new PVector(0,0,0);
     PVector.sub(b.pos, a.pos, atob);
     
     float f = -G*a.m*b.m / atob.magSq();
     
     atob = atob.normalize();
     atob = atob.mult(f);
     
     return atob;
     
  }
  
  float getThetaDoubleDot(float theta, float thetaDot) {
    return -mu * thetaDot - (g / L) * sin(theta);
  }
  
  float theta(float t) {
    float theta = THETA_0;
    float thetaDot = THETA_DOT_0;
    float delta_t = 0.01;
    
    for(float time = 0; time < t; time += delta_t) {
      float thetaDoubleDot = getThetaDoubleDot(theta, thetaDot);
      theta += thetaDot * delta_t;
      thetaDot += thetaDoubleDot * delta_t;
    }
    return theta;
  }
  
  
}
