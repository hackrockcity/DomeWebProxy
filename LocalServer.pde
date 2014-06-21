public class LocalServer {
  int port;
  
  public LocalServer(int port) {
      this.port = port;
      new ServerThread().start();
  }
  
  public class ServerThread extends Thread {
    Server server;
    
    @Override
    public void run() {
      server = new Server(new InetSocketAddress(LocalServer.this.port));
      server.start();
    }
  }

  public class Server extends WebSocketServer {
    public Server(InetSocketAddress address) { super(address); }
    
    @Override
    public void onError(WebSocket c, Exception e) { e.printStackTrace(); }
    
    @Override
    public void onOpen(WebSocket conn, ClientHandshake handshake) { 
      conn.send("{\"yo\":\"phone\"}"); 
      System.out.println(conn + " connected"); 
    }
    
    @Override
    public void onClose(WebSocket conn, int code, String reason, boolean remote) { System.out.println(conn + " disconnected"); }
  
    @Override
    public void onMessage(WebSocket conn, String message) {
      println(message); 
      LocalServer.this.onMessage(new Message(message)); 
    }
  }
  
  public void onMessage(Message message) {}
}

