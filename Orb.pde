class Orb {
  int x;
  int y;
  boolean enabled;
  int ticks;
  int hue;
  String mode;
  
  public Orb(Message m) {
    this.x = m.x;
    this.y = m.y;
    this.hue = m.hue;
    this.ticks = ORBTICKS;
    this.enabled = true;
    this.mode = m.mode;
  }
  
  void setPosition(int a, int b, int g) {
  }
  
  void draw(PGraphics g) {
    if (enabled) {
      g.pushStyle();
      g.blendMode(ADD);
      g.colorMode(HSB, 360);
      g.noStroke();
      g.fill(hue, 360, 270-ticks*(270/ORBTICKS));
      if (mode.equals("l")) {
        g.rect(x,y,40,4);
      } else {
        g.ellipse(x,y,3,12);
      }
      g.popStyle();    
    
      ticks--;
      if (ticks == 0) enabled = false;
    }
  }
  
  
  
}
