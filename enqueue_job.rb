require 'active_job'

# To run and test the pubsub adapter, open a Rails console and run the following command:

job = MyJob.set(queue: 'job_data_sub').perform_later('test_arg1', 'test_arg2')