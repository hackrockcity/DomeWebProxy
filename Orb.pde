class Orb {
  int x;
  int y;
  boolean enabled;
  int tick;
  int ticks;
  int hue;
  int size;
  int brightness;
  int boff;
  boolean fire;
  boolean paint;
  boolean pulse;
  
  public Orb(Message m) {
    this.x = m.x;
    this.y = m.y;
    this.hue = m.hue;
    this.size = m.size;
    this.fire = m.fire;
    this.paint = m.paint;
    this.pulse = m.pulse;
    this.ticks = (11 - this.size) * 10;
    this.tick = this.ticks; 
    this.enabled = true;
    this.brightness = m.pulse ? 180 : 360;
    this.boff = 180/(this.ticks/8);
  }
  
  void draw(PGraphics g) {
    if (enabled) {
      if (this.paint) this.y++;
      if (this.pulse) this.brightness += this.boff;     
      
      g.pushStyle();
      g.blendMode(ADD);
      g.colorMode(HSB, 360);
      g.noStroke();
      g.fill(hue, this.brightness, 270-tick*(270/ticks));
      g.ellipse(this.x,this.y,this.size,this.size*3);
      g.popStyle();    
    
      if (this.fire) this.applyFire(g);
    
      tick--;
      if (tick == 0) enabled = false;
      else if (this.pulse && tick % 8 == 0) this.boff = -this.boff;
      
    }
  }
  
  void applyFire(PGraphics g) {
    int y;
    int x;
    int idx;
    int lidx;
    int ridx;
  
    g.loadPixels();
    
    for (y=this.y-this.size*3/2+4; y>this.y-this.size*4; y--) {
      for (x=this.x-this.size/2-1; x<this.x+this.size/2+1; x++) {
        idx = constrain(y*WIDTH+x,0,g.pixels.length-1);
        lidx = constrain((y+1)*WIDTH+x-1,0,g.pixels.length-1);
        ridx = constrain((y+2)*WIDTH+x+1,0,g.pixels.length-1);
        
        g.pixels[idx] = color(
          (red(g.pixels[lidx])+red(g.pixels[ridx]))/2+random(10),  
          (green(g.pixels[lidx])+blue(g.pixels[ridx]))/2+random(10),  
          (blue(g.pixels[lidx])+blue(g.pixels[ridx]))/2 
        );
      }
    }
    
    g.updatePixels();
  }
  
}
