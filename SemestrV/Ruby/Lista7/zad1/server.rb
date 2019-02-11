# frozen_string_literal: true

require "yaml"
require "drb"

class Logger
  def initialize
    @file = "log.yml"
    @log = if File.exist? @file
             open(@file, "r") { |f| YAML.safe_load(f, [Time]) }
           else
             {}
           end
  end

  def save(prg_id, msg)
    if @log.key? prg_id
      @log[prg_id][Time.now] = msg
    else
      @log[prg_id] = { Time.now => msg }
    end
    open(@file, "w") { |f| YAML.dump(@log, f) }
    "Saved"
  end

  def report(from, to, prg_id, re)
    results = "<html>\n<body>\n"
    if @log.key? prg_id
      @log[prg_id].each do |k,v|
        results += "<div>" + k.to_s + ": " + @log[prg_id][k] + "</div>\n" if (k >= from) && (k <= to) && @log[prg_id][k] =~ re
      end
    end
    results += "</body>\n</html>"
  end

  def self.run
    @@server = Logger.new
    DRb.start_service("druby://localhost:6666", @@server)
    DRb.thread.join
  end
end

Logger.run
