import java.net.URI;
import java.util.ArrayList;
import java.util.Iterator;
import org.java_websocket.WebSocket;
import org.java_websocket.WebSocketImpl;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.server.WebSocketServer;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_10;
import org.java_websocket.drafts.Draft_17;
import org.java_websocket.drafts.Draft_75;
import org.java_websocket.drafts.Draft_76;
import org.java_websocket.handshake.ServerHandshake;
import org.java_websocket.handshake.ClientHandshake;
import java.net.InetSocketAddress;

// Configuration
int WIDTH = 40;
int HEIGHT = 160;
int ZOOM = 2;
String HOST = "127.0.0.1";
int PORT =  58082;
int ORBTICKS = 30;
String WSCURL = "ws://www.domestar.us:8000/dome";
int WSSPORT = 8000;

// List of color ellipses created by touching
ArrayList<Orb> orbs;

// LED Display
LEDDisplay display;

// Graphics layer used for drawing 
// We use a separate PGraphics so we can have zoom on screen
PGraphics g;

// ProxyClient connects to domestar.us to get messages from
// clients that cannot connect directly to this server
ProxyClient pc;

LocalServer server;

HashMap<String,Message> status;


void setup() {
  size(WIDTH*ZOOM*4,HEIGHT*ZOOM);
  frameRate(30);
  g = createGraphics(WIDTH,HEIGHT);
  display = new LEDDisplay(this,WIDTH,HEIGHT,true,HOST,PORT);
  orbs = new ArrayList<Orb>();
  status = new HashMap<String,Message>();
  
  // Setup proxy client.  New messages create new orbs.
  pc = new ProxyClient(WSCURL) {
      @Override
      public void onMessage(Message message) {
        synchronized(orbs) {
          orbs.add(new Orb(message));
          status.put(message.id,message);
        }
      }
  }; 
  
  // Setup server.
  server = new LocalServer(WSSPORT) {
    @Override
    public void onMessage(Message message) {
      synchronized(orbs) {
        orbs.add(new Orb(message));
        status.put(message.id,message);
      }
    }
  };
}

void drawSpokes() { 
  pushMatrix();
  colorMode(RGB);
  stroke(0);  
  translate(WIDTH*ZOOM*2.5,HEIGHT*ZOOM/2);

  for (int i=0; i<WIDTH; i++) {
    rotate(TWO_PI/WIDTH);
    line(0,10,1,HEIGHT*ZOOM/3);
  }
  popMatrix();

  for (Message m : status.values()) {
    pushMatrix();
    translate(WIDTH*ZOOM*2.5,HEIGHT*ZOOM/2);
    rotate(TWO_PI/WIDTH*m.x);
    colorMode(HSB,360);
    stroke(m.hue, 360, 360);
    line(0,10,1,HEIGHT*ZOOM/3);
    popMatrix();
  }
}

void draw() {
  background(255);
  
  // Draw to the graphics layer
  g.beginDraw();
  g.background(0);

  // Draw all the orbs
  synchronized(orbs) {
    for (Orb o : orbs) {
        o.draw(g);
    }
  }
  g.endDraw();
 
  // Copy/scale graphics layer to screen
  image(g,0,0,WIDTH*ZOOM,HEIGHT*ZOOM);
  
  // Load pixels from and send to LED display
  g.loadPixels();
  display.sendData(g.pixels);

  drawSpokes();
  
  // Remove any orbs that have finished.
  synchronized(orbs) {
    for (Iterator<Orb> itr = orbs.iterator(); itr.hasNext();) {
      Orb o = itr.next();
      if (!o.enabled) itr.remove();
    }
  }
  
  // Clear the status every now and again to wipe dead clients
  if (frameCount % (frameRate*10) == 0) status.clear();
}

