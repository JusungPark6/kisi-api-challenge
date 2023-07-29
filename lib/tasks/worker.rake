# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html
    sub = @client.subscription "job_data sub"
    subscriber = sub.listen do |received_message|
      enqueue_set_time = received_message.attributes().dig.enqueued_at
      puts "received message with job id: #{received_message.attritube().dig.job_id}"
      @PubsubAdapter.enqueue_at(received_message, enqueue_set_time.to_f)
      received_message.acknowledge!
    end
    subscriber.on_error do |exception|
      puts "Exception: #{exception.class} #{exception.message}"
    end
    at_exit do
      subscriber.stop!(10)
    end
    puts("Worker starting...")
    subscriber.start
    # Block, letting processing threads continue in the background
    sleep
  end
end
