class RabbitmqService
  def self.subscribe(queue)
    connection = Bunny.new
    connection.start

    channel = connection.create_channel
    queue = channel.queue(queue)

    begin
      puts 'Waiting for messages...'
      queue.subscribe(block: true) do |_delivery_info, _properties, body|
        data = JSON.parse(body)
        yield(data)
      end
    rescue Interrupt => _
      connection.close
    end
  end
end