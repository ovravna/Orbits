class God {
  int viewIndex = 0;
  Planet viewPlanet;
  
  boolean lockView = false;
  
  ArrayList<Planet> planets;
  Physics p;
  Sun sun;
  God() {
    planets = new ArrayList<Planet>();
    
  }
  
  Sun letThereBeLight(float r, float m, PVector initPos, PVector initForce) {
    sun = new Sun(planets.size(), r, m, initPos, initForce, drawLine);
    planets.add(sun);
    changeView(0);
    return sun;
  }
  
  void changeView(int i) {
    God.viewIndex += i;
    if (God.viewIndex < 0) God.viewIndex += God.planets.size();
    God.viewIndex %= God.planets.size(); 
    viewPlanet = planets.get(viewIndex);
    
  }
  
  Planet cratePlanet(float r, float m, PVector initPos, PVector initForce, color c) {
    Planet p = new Planet(planets.size(), r, m, initPos, initForce, c, drawLine);
    planets.add(p);
    return p;
  }
  
  Physics cratePhysics(float g, float L, float mu, float G) {
    this.p = new Physics(g, L, mu, G);
    return p;
  }
  
  void toggleDrawLines() {
    drawLine = !drawLine;
    for (Planet pl : planets) { 
        pl.drawLine = drawLine;
    }
  }
  
  void doPhysics() {
    
    for (Planet pl : planets) {
       
       
       pl.resetFrame();
       //if (pl.id == 0) continue;
       for (Planet pn : planets) {
           if (pl == pn) {
             continue;
           }
           
           PVector pv = pl.gravityFrom(pn).mult(p.G);
                   
           pl.applyForce(pv);
       }
  
             
       
       pl.move();
    }
    
    
  }
  
  void setCamVector(float x, float y, float z) {
    Rotation rot = new Rotation(new Vector3D(0,0,10),new Vector3D(x,y,z));
    cam.setState(new CameraState(rot, new Vector3D(0,0,0), cam.getDistance()));
  }
    
  void show() {
    
    
    
    if (lockView && sun != viewPlanet) {
      PVector d = sun.pos.copy().sub(viewPlanet.pos);
      setCamVector(d.x, d.y, d.z);
    }
    
    cam.lookAt(viewPlanet.pos.x, viewPlanet.pos.y, viewPlanet.pos.z, 0L);
    for (Planet p: planets) 
      p.draw();
      
    
    cam.beginHUD();
    fill(255);
    
    double zoom;
    float[] c;
    c = cam.getPosition();
    
    zoom = cam.getDistance();
    
    text(String.format("(%.1f | %d)  %.2f",frameRate, frameCount, zoom), 8, 16);
    int n = 4;
    fill(planets.get(viewIndex).c);
    text(String.format("[% 7.0f, % 7.0f, % 7.0f]", 
      viewPlanet.pos.x, viewPlanet.pos.y, viewPlanet.pos.z), 8, 2 * 16);
    fill(255);
    text(String.format("%1$-20s%2$-20s%3$-20s", "Distance", "Speed", "Acceleration"), 8, 3 * 16);
    for (Planet p: planets) {
      fill(p.c);
      if (false) {
        //p == planets.get(viewIndex)
        text(String.format("[% 7.0f, % 7.0f, % 7.0f] %16.5g %16.5g", p.pos.x, p.pos.y, p.pos.z, p.getSpeed(), p.getForce()), 8, n * 16);
        
      } else {
        PVector pv = p.pos.copy();
        text(String.format("%1$-20.5e%2$-20.5e%3$-20.5e", pv.sub(viewPlanet.pos).mag(), p.getSpeed(), p.getForce()), 8, n * 16);
      }
      n++;
    } 
    cam.endHUD();
    
      
  }
  
}
