import peasy.*;
import peasy.org.apache.commons.math.geometry.Rotation;
import peasy.org.apache.commons.math.geometry.RotationOrder;
import peasy.org.apache.commons.math.geometry.Vector3D;
import java.util.Locale;

PeasyCam cam; 

Planet p1, p2;

Physics p;
God God;
boolean drawAxis = true;
boolean drawLine = true; 
boolean stopTime = false;
boolean frameBound = false;

PShape sun_;
PImage suntex;

PShape planet1;
PImage surftex1;
int fps = 60;
void setup() {
  Locale.setDefault(new Locale("en", "US"));   
  frameRate(fps);
  size(720, 720, P3D); 
  cam = new PeasyCam(this, 0, 0, 0, 2000);
  cam.setMinimumDistance(40);
  God = new God();
  suntex = loadImage("sun.jpg");  
  surftex1 = loadImage("planet.jpg");  
  
  
  
  God.cratePhysics(9.8, 2000, 0.1, 0.06); 
  //God.cratePlanet(3, 3000, new PVector(50, 50, 0), new PVector(5, -5, 0), #ff0000 );
  //God.cratePlanet(3, pow(10, 4), new PVector(pow(10, 6), 10000, 100), new PVector(10000, 0,0), #ff00ff);
  //God.cratePlanet(3, pow(10, 10), new PVector(pow(10, 6), -100, -10000), new PVector(0, 0,0), #ff66ff);
  //God.cratePlanet(3, 1, new PVector(100, 100, 0), new PVector(5, 0, -5), #00ff00);
  
  Sun sun = God.letThereBeLight(25, 10000000, new PVector(0, 0, 0), new PVector(2, 1, 2).normalize().mult(3));
  
  int rad = 1000;
  PVector v = circularV(-3, 2, 2, rad, sun);
  PVector r = circularR(1, 1, 0, rad);
  
  Planet p1 = God.cratePlanet(3, 20000, r, v, #7777ff);
  
  int rad2 = 20;
  PVector v1 = circularV(-2, -3, 4, rad2, p1);
  PVector r1 = circularR(0,0,10, rad2);
  
  God.cratePlanet(1, 0.1, r.copy().add(r1), v.copy().add(v1), #bbbbff);
  
  noStroke();
  
}

PVector circularR(float x, float y, float z, float r) {
  
  return new PVector(x, y, z).normalize().mult(r);
}

PVector circularV(float x, float y, float z, float r, Planet o) {
  PVector v = new PVector(x, y, z);
  
  v = v.normalize();
  return v.mult(sqrt(God.p.G * o.m / r));
  
}

void mouseClicked() {
  
  God.toggleDrawLines();
 
}
long lastPressed = 0;
void keyPressed() {

  if (key == CODED && keyCode == DOWN) { 
    God.changeView(1);
  }
  if (key == CODED && keyCode == UP) {
    God.changeView(-1);
  }
  
  if (key == ' ') {
    stopTime = !stopTime;
  }
  
  if (key == CODED && keyCode == RIGHT) { 
    fps += 10;
    frameRate(fps);
  }
  if (key == CODED && keyCode == LEFT) {
    if (fps < 11) return;
    fps -= 10;
    frameRate(fps);
  }
  
  float l = 0.1;
  if (key == 'w') { 
    cam.rotateX(l);
  }
  if (key == 's') { 
    cam.rotateX(-l);
  }
  if (key == 'a') { 
    cam.rotateY(-l);
  }
  if (key == 'd') { 
    cam.rotateY(l);
  }
  if (key == 'e') { 
    cam.rotateZ(l);
  }
  if (key == 'q') { 
    cam.rotateZ(-l);
  }
  
  if (key == 'L') { 
    God.lockView = !God.lockView;
  }
  
  if (key == 'k') { 
    God.planets.get(God.viewIndex).m = 0;
  }
  
  if (key == 'j') { 
    God.planets.get(God.viewIndex).m *= 0.9;
  }
  if (key == 'l') { 
    God.planets.get(God.viewIndex).m *= 1.1;
  }
  
  if (key == 'z') { 
    cam.setDistance(cam.getDistance()*1.1);
  }
  if (key == 'x') { 
    cam.setDistance(cam.getDistance()*0.9);
  }
  
  if (key == 'f') { 
    frameBound = !frameBound;
  }
  
  if (stopTime) {
    if (key == 'n') { 
        God.undoPhysics(); 

    }
    if (key == 'm') { 
      
      God.doPhysics();
    }
  }
}


float F = 60.0;
float sumFrameScore = 0;
void draw() {
  background(0);
 
  //sphereDetail(14);
  
  if (drawAxis) {
    float axlen = (float) cam.getDistance();
    pushMatrix();
    translate(God.viewPlanet.pos.x, God.viewPlanet.pos.y, God.viewPlanet.pos.z);
    line(0, -axlen, 0, 0, axlen, 0); 
    line(-axlen, 0, 0, axlen, 0, 0); 
    line(0, 0, -axlen, 0, 0, axlen); 
    
    popMatrix();
  }
  
  if (stopTime) {
    
  } else if (frameBound) {
    God.doPhysics();
  } else {
    float frameScore = F / frameRate; 
    
    sumFrameScore += frameScore;
   
    while (sumFrameScore > 1) {
    
      God.doPhysics();
      sumFrameScore--;
    }
  
  }
  God.show();

}



/*
  God.letThereBeLight(15, 10000000, new PVector(0, 0, 0), new PVector(0, 0, 0));
  PVector v = new PVector(-3, 2, 2);
  int rad = 1000;
  v = v.normalize();
  v = v.mult(sqrt(God.p.G * God.sun.m / rad));
  
  PVector r = new PVector(1, 1, 0).normalize().mult(rad);
  
  God.cratePlanet(3, 100000, r, v, #7777ff);
  God.cratePlanet(1, 0.0001, new PVector(r.x, r.y + 1, r.z - 60), new PVector(v.x-3, v.y-3 , v.z + 7), #bbbbff);
*/
