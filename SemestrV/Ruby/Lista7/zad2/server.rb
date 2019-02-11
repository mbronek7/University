# frozen_string_literal: true

require 'open3'
require "drb"

class Server
  def cpu_usage_info
    stdin, stderr, status = Open3.capture3(%q(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}'))
    "CPU:  #{stdin}"
  end

  def memory_usage_info
    stdin, stderr, status = Open3.capture3("df")
    "Memory:\n #{stdin}"
  end

  def report
    data = cpu_usage_info
    data + memory_usage_info
  end
end

def run_new_server(port: 9999, server: Server.new)
  DRb.start_service("druby://localhost:#{port}", server)
end

run_new_server
DRb.thread.join