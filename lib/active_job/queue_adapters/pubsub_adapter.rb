# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        
        topic = @client.topic("job_data")
        job_data = {
          "job_class"  => self.class.name,
          "job_id"     => job_id,
          "provider_job_id" => provider_job_id,
          "queue_name" => queue_name,
          "priority"   => priority,
          "arguments"  => serialize_arguments_if_needed(arguments),
          "executions" => executions,
          "exception_executions" => exception_executions,
          "locale"     => I18n.locale.to_s,
          "timezone"   => timezone,
          "enqueued_at" => Time.local(year, month, day, hour, min)
        }
        job_data_json = job_data.to_json
        job_data_json = topic.publish "new message"
        
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        delay = timestamp - Time.current.to_f
        if delay > 0
          PubsubAdapter.set(wait: delay).perform_later(job)
        else
            enqueue(job)
        end
      end
    end
  end
end
