# included into ActiveRecord models
module ServerPush

  # Can be overridden in model to limit who gets updates
  # Returns a list of sockets (by default all of them)
  def publish_to
    Sockets.to_a
  end

  def send_to_socket(socket, data)
    EM.next_tick { socket.send data }
  end
  
  def save(*args)
    should_push = valid? && !persisted?
    result = super(*args)
    if should_push
      publish_to.each do |socket|
        send_to_socket socket, {
          action: "add_record",
          type: self.class.to_s.underscore,
          record: public_attributes
        }.to_json
      end
    end
    result
  end

  def update(*args)
    result = super(*args)
    if result
      publish_to.each do |socket|
        send_to_socket socket, {
          action: "update_record",
          type: self.class.to_s.underscore,
          record: public_attributes  
        }.to_json
      end
    end
    result
  end

  def destroy(*args)
    result = super(*args)
    unless persisted?
      publish_to.each do |socket|
        send_to_socket socket, {
          action: "destroy_record",
          type: self.class.to_s.underscore,
          record: public_attributes  
        }.to_json
      end
    end
    result
  end  

end
