# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
    def perform(job)
        put "executed job"
    end
end
