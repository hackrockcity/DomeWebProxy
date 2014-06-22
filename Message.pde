class Message {
  int alpha;
  int beta;
  int gamma;
  String touch;
  String id;
  int hue;
  int x;
  int y;
  String mode;
  
  public Message(String JSON) {
    JSONObject jso = JSONObject.parse(JSON);
    this.alpha = jso.getInt("a");
    this.beta = jso.getInt("b");
    this.gamma = jso.getInt("g");
    //this.touch = jso.getString("t");
    this.id = jso.getString("id");
    this.hue = jso.getInt("c");
    this.mode = jso.getString("m");
    this.calculatePosition();
  }
  
  public void calculatePosition() {
    int xang = (this.alpha + this.gamma) % 360;
    if (xang < 0) xang += 360;
        
    this.x = int((360-xang)/360.0*WIDTH+WIDTH/2);
    if (this.x>WIDTH) this.x-=WIDTH;
 
    // 0=flat, 90=up, -90=down
    int yang = this.beta + 30;   
    if (yang<0) yang=0;
    this.y = int((120-yang)/120.0*HEIGHT);
  }
}

