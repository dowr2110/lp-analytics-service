class RabbitmqService
  def self.subscribe(queue)
    connection = if ENV['RABBITMQ_URL'].present?
                   Bunny.new(host: 'rabbitmq', port: 5672, automatically_recover: true)
                 else
                   Bunny.new
                 end
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