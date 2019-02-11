# frozen_string_literal: true

require "drb"
require "rufus-scheduler"

SCHEDULER = Rufus::Scheduler.new

class Client
  @@instances = []

  def add_server(port: 9999)
    new_server = DRbObject.new_with_uri("druby://localhost:#{port}")
    p new_server
    @@instances << new_server
  end

  def self.report_all
    @@instances.each do |server|
      print server.report if server.respond_to? "report"
    end
  end

  def run_sheduled_job
    SCHEDULER.every '1m' do
      self.report_all
    end
  end
end
