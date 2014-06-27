class Orb {
  int x;
  int y;
  boolean enabled;
  int tick;
  int ticks;
  int hue;
  int size;
  
  public Orb(Message m) {
    this.x = m.x;
    this.y = m.y;
    this.hue = m.hue;
    this.size = m.size;
    this.ticks = (11 - this.size) * 10;
    this.tick = this.ticks; 
    this.enabled = true;
  }
  
  void draw(PGraphics g) {
    if (enabled) {
      g.pushStyle();
      g.blendMode(ADD);
      g.colorMode(HSB, 360);
      g.noStroke();
      g.fill(hue, 360, 270-tick*(270/ticks));
      g.ellipse(x,y,this.size,this.size*3);
      g.popStyle();    
    
      tick--;
      if (tick == 0) enabled = false;
    }
  }
  
  
  
}
