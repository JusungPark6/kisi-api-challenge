# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html
    pubsub = Pubsub.new
    sub = pubsub.subscription("job_data_sub")
    
    subscriber = sub.listen do |received_message|
      job_data = JSON.parse(received_message.data)
      job = ActiveJob::Base.deserialize(job_data)
      job.perform_now
      
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
    sleep
  end
end
