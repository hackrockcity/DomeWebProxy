import java.net.URI;
import java.util.HashMap;
import org.java_websocket.WebSocketImpl;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_10;
import org.java_websocket.drafts.Draft_17;
import org.java_websocket.drafts.Draft_75;
import org.java_websocket.drafts.Draft_76;
import org.java_websocket.handshake.ServerHandshake;

int WIDTH = 40;
int HEIGHT = 160;
int ZOOM = 2;
String HOST = "127.0.0.1";
int PORT =  58082;
String WSURL = "ws://www.domestar.us:8000/dome";

HashMap<String,Orb> orbs;
WebSocketClient cc;
LEDDisplay display;
PGraphics g;

void setup() {
  size(WIDTH*ZOOM,HEIGHT*ZOOM);
  g = createGraphics(WIDTH,HEIGHT);
  display = new LEDDisplay(this,WIDTH,HEIGHT,true,HOST,PORT);
  orbs = new HashMap<String,Orb>(); 
  
  try {
    println("Connecting...");
    cc = new WebSocketClient(new URI(WSURL)) {
      @Override
      public void onMessage(String message) {
        //println(message);
        JSONObject jso = JSONObject.parse(message);
        JSONObject data = jso.getJSONObject("data");
        JSONObject o = data.getJSONObject("o");
        int a = o.getInt("a");
        int b = o.getInt("b");
        int g = o.getInt("g");
        String touch = data.getString("touch");
        String id = jso.getString("id");
        
        if (touch.equals("start")) {
          orbs.put(id,new Orb(a,b,g));
        }
        else if (touch.equals("down")) {
          orbs.get(id).setPosition(a,b,g);
        }
        
      }
    
      @Override
      public void onError(Exception e) { println(e); }
    
      @Override
      public void onClose(int n,String s,boolean b) { println("Close"+n+s+b); }
    
      @Override
      public void onOpen(ServerHandshake sh) { println("Connect"); }
    
    };
  }
  catch (Exception e) { println(e); }
  cc.connect();
}

void draw() {
  g.beginDraw();
  g.background(0);
  
  for (Orb o : orbs.values()) {
    o.draw(g);
  }
    
  g.endDraw();
  image(g,0,0,width,height);
  g.loadPixels();
  display.sendData(g.pixels);
  
}

