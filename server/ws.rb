class Ws

  def self.run(request)
    return unless Faye::WebSocket.websocket?(request.env)
    socket = Faye::WebSocket.new(request.env)
    socket.onopen = Proc.new { |e| onopen(request, socket) }
    socket.onmessage = Proc.new { |e| onmessage(request, socket, e.data) }
    socket.onclose = Proc.new { |e| onclose(request, socket) }
    socket.rack_response
  end

  def self.onopen(request, ws)
    Sockets << ws
  end

  def self.onmessage(request, ws, msg_data)
    data = JSON.parse msg_data
  end

  def self.onclose(request, ws)
    Sockets.delete ws
  end

end
