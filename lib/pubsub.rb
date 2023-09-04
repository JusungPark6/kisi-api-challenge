# frozen_string_literal: true

require("google/cloud/pubsub")

class Pubsub
  # Find or create a topic.
  #
  # @param topic [String] The name of the topic to find or create
  # @return [Google::Cloud::PubSub::Topic]
  def topic(name)
    client.topic(name) || client.create_topic(name)
  end

  def subscription(name)
    sub = client.subscription(name)
  
    unless sub
      topic_name = "job_data_sub"
      topic = client.topic(topic_name) || client.create_topic(topic_name)
    
      begin
        sub = topic.subscribe(name)
      rescue => e
        puts "Error creating subscription: #{e.message}"
        return nil
      end
    end
  
    sub
  end

  private

  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  def client
    @client ||= Google::Cloud::PubSub.new(project_id: "code-challenge")
  end
end
