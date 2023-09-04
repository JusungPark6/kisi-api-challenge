# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      attr_reader :pubsub
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        pubsub = Pubsub.new
        topic = pubsub.topic("job_data_sub")
        serialized_job = job.serialize
        message = topic.publish(serialized_job.to_json)
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        job.scheduled_at = timestamp
        enqueue(job)
      end
    end
  end
end
