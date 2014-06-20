class Orb {
  int x;
  int y;
  
  public Orb(int a, int b, int g) {
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
    g.stroke(255);
    g.point(x,y);
  }
  
  
  
}
