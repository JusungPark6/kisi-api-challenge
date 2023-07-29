require 'active_job'

# To run and test the pubsub adapter, open a Rails console and run the following command:

job = MyJob.new
job.perform_later