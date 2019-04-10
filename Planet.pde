

class Planet {
  int index;

  float r, m;
  PVector pos;
  ArrayList<PVector> line;
  PVector force;
  PVector frameForce;
  int id; 
  boolean drawLine;
  PShape shape;
  color c;
  Planet(int id, float r, float m, PVector initPos, PVector initForce, color c, boolean drawLine) {
    this.id = id;
    this.r = r; 
    this.m = m;
    this.c = c;
    this.drawLine = drawLine;
    shape = createShape(SPHERE, r);
    shape.setTexture(surftex1);
   
    this.pos = initPos;
    line = new ArrayList<PVector>();
    line.add(initPos);
    
    force = initForce; 
    resetFrame();
    
  }
  

   
  
  void move(float x, float y, float z) {
    pos = new PVector(x, y, z);
    line.add(pos);
  
  }
  
  void move() {
     
      pos = pos.add(force);
      //println(id + " at " + pos);
      line.add(pos.copy());
     
     
  }
  
  void applyForce(PVector force) {
      this.force = this.force.add(force);
      this.frameForce = this.frameForce.add(force);
      
  }
  
  float getForce() {
    return frameForce.mag();
  }
  
  void resetFrame() {
    frameForce = new PVector(0,0,0); 
  }
  
  PVector gravityFrom(Planet other) {
     PVector atob = new PVector(0,0,0);
     PVector.sub(other.pos, pos, atob);
     float f = other.m / atob.magSq();
     atob = atob.normalize();
     return atob.mult(f);
  }
  
  float getSpeed() {
    return force.mag(); 
  }
  
  void draw() {
     
     stroke(200);
     strokeWeight(0.5);
     fill(c);
     pushMatrix();
     
     translate(pos.x, pos.y, pos.z);
     sphere(r);
     popMatrix();
     
     if (drawLine) {
       stroke(c);
       strokeWeight(1);
       PVector v0, v1;   
       int n = 10000;
       int m = 1;
       int i = line.size() < n + (m + 1) ? (m + 1) : line.size() - n;
       for (; i < line.size(); i+=m) {
        v1 = line.get(i);
        v0 = line.get(i-m);
        //point(v1.x, v1.y, v1.z);
        line(v0.x, v0.y, v0.z, v1.x, v1.y, v1.z); 
       }
       noStroke();
    }
    
  }
  
}
