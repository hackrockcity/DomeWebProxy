class Message {
  int alpha;
  int beta;
  int gamma;
  int cAlpha;
  int cBeta;
  String id;
  int hue;
  int x;
  int y;
  int size;
  boolean calibrated;
  boolean fire;
  boolean pulse;
  boolean paint;

  // TODO FIXME Rethink calibration vs. non-calibration...  
  public Message(String JSON) {
    JSONObject jso = JSONObject.parse(JSON);
    this.alpha = jso.getInt("a");
    this.beta = jso.getInt("b");
    this.gamma = jso.getInt("g");
    this.id = jso.getString("id");
    this.hue = jso.getInt("c");
    this.size = jso.getInt("s");
    
    // This is kind of gross feeling.
    if (jso.hasKey("A") && jso.hasKey("B")) {
      this.calibrated = false;
      this.cAlpha = jso.getInt("A");
      this.cBeta = jso.getInt("B");
    }
    else {
      this.calibrated = false;
      this.cAlpha = -65535;
      this.cBeta = -65535;
    }
    
    this.fire = jso.hasKey("f") && jso.getInt("f") == 1;
    this.pulse = jso.hasKey("p") && jso.getInt("p") == 1;
    this.paint = jso.hasKey("P") && jso.getInt("P") == 1;
    
    this.calculatePosition();    
  }
  
  public void calculatePosition() {
    int xang = this.calibrated ? this.cAlpha : this.alpha;
    if (xang < 0) xang += 360;
        
    this.x = int((360-xang)/360.0*WIDTH+WIDTH/2);
    if (this.x>WIDTH) this.x-=WIDTH;
 
    // 0=flat, 90=up, -90=down
    int yang = this.calibrated ? this.cBeta : this.beta + 30;   
    if (yang<0) yang=0;
    this.y = int((120-yang)/120.0*HEIGHT);
  }
}

