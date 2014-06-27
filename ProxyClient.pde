
class ProxyClient {
  WebSocketClient cc;
  String url;
  
  public ProxyClient(String url) {
      this.url = url;
      this.connect();
  }
  
  public void connect() {
    try {
        this.cc = new WebSocketClient(new URI(this.url)) {
      
        @Override
        public void onMessage(String message) {
          ProxyClient.this.onMessage(new Message(message));
        }
    
        @Override
        public void onError(Exception e) { println(e); }
    
        @Override
        public void onClose(int n,String s,boolean b) { println("Proxy connection closed. Reconnecting."); ProxyClient.this.connect(); }
    
        @Override
        public void onOpen(ServerHandshake sh) { println("Connected to proxy server."); }    
      };
    
      println("Connecting...");
      this.cc.connect();
    }
    catch (Exception e) { println(e); }
  }
  
  public void onMessage(Message message) {}
}
