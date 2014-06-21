import java.net.URI;
import java.util.ArrayList;
import java.util.Iterator;
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
int ORBTICKS = 30;
String WSURL = "ws://www.domestar.us:8000/dome";

ArrayList<Orb> orbs;
WebSocketClient cc;
LEDDisplay display;
PGraphics g;

void setup() {
  size(WIDTH*ZOOM,HEIGHT*ZOOM);
  frameRate(30);
  
  g = createGraphics(WIDTH,HEIGHT);
  display = new LEDDisplay(this,WIDTH,HEIGHT,true,HOST,PORT);
  orbs = new ArrayList<Orb>(); 
  
  try {
    println("Connecting...");
    cc = new WebSocketClient(new URI(WSURL)) {
      @Override
      public void onMessage(String message) {
        //println(message);
        JSONObject jso = JSONObject.parse(message);
        int a = jso.getInt("a");
        int b = jso.getInt("b");
        int g = jso.getInt("g");
        String touch = jso.getString("t");
        String id = jso.getString("id");
        int c = jso.getInt("c");
        
        synchronized(orbs) {
          orbs.add(new Orb(a,b,g,c));
        }        
      }
    
      @Override
      public void onError(Exception e) { println(e); }
    
      @Override
      public void onClose(int n,String s,boolean b) { println("Connection closed. Reconnecting."); cc.connect(); }
    
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
  
  synchronized(orbs) {
    for (Iterator<Orb> itr = orbs.iterator(); itr.hasNext();) {
      Orb o = itr.next();
      o.draw(g);
      if (!o.enabled) itr.remove();
    }
  }
    
  g.endDraw();
  image(g,0,0,width,height);
  g.loadPixels();
  display.sendData(g.pixels);
  
}

