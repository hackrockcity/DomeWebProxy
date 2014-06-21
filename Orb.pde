class Orb {
  int x;
  int y;
  boolean enabled;
  int ticks;
  int hue;
  
  public Orb(int a, int b, int g, int h) {
    hue = h;
    ticks = ORBTICKS;
    enabled = true;
    this.setPosition(a,b,g);
  }
  
  void setPosition(int a, int b, int g) {
    int xang = (a+g) % 360;
    if (xang < 0) xang += 360;
        
    x = int((360-xang)/360.0*WIDTH+WIDTH/2);
    if (x>WIDTH) x-=WIDTH;
 
    // 0=flat, 90=up, -90=down
    int yang = b + 30;   
    if (yang<0) yang=0;
    y = int((120-yang)/120.0*HEIGHT);
  }
  
  void draw(PGraphics g) {
    if (enabled) {
      g.pushStyle();
      g.blendMode(ADD);
      g.colorMode(HSB, 360);
      g.noStroke();
      g.fill(hue, 360, 270-ticks*(270/ORBTICKS));
      g.ellipse(x,y,3,12);
      g.popStyle();    
    
      ticks--;
      if (ticks == 0) enabled = false;
    }
  }
  
  
  
}
