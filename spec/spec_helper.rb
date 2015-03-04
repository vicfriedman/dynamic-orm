ENV["ACTIVE_RECORD_ENV"] = "test"

require_relative '../config/environment'

RSpec.configure do |config|
end

def run_rake_task(task)
  RAKE_APP[task].invoke
end

def __
  raise "Replace __ with test code."
end
