class Caracol extends FBox {

  float x, y, dir, vel;


  Caracol(float ancho_, float alto_) {

    super(ancho_, alto_);
    

    vel = 2;
    dir = 30;
  }

  void inicializar(float x_, float y_) {

    x = x_;
    y = y_;
    
    setPosition(x, y);
    setName("caracol");
    //setStatic(true);
    setGrabbable(false);
    setRotatable(false);
    setDensity(100.0);
    setRestitution(0.5);
    
  }

  void Subiendo() {
  }
}
