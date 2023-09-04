class MyJob < ApplicationJob
    def perform(*args)
      puts "Job executed with arguments: #{args.inspect}"
    end
  end