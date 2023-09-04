require 'active_job'

job = MyJob.set(queue: 'job_data_sub').perform_later('test_arg1', 'test_arg2')