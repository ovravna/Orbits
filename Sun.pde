
class Sun extends Planet {

  Sun(int id, float r, float m, PVector initPos, PVector initForce, boolean drawLine) {
    super(id, r, m, initPos, initForce, #ffff00, drawLine);
    super.shape.setTexture(suntex);  

  }
  
  void draw() {
    noStroke();
    super.draw();
    noLights();
    pointLight(255,  255,  255,  pos.x, pos.y, pos.z); 
  
  }
}
