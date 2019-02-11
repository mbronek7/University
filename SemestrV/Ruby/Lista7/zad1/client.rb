# frozen_string_literal: true

require "drb"
require "faker"

REMOTE = DRbObject.new_with_uri("druby://localhost:6666")

class Client
  @@id = 0

  def initialize
    @@id += 1
    @id = "prog_#{@@id}"
  end

  def send_logs_to_save
    REMOTE.save(@id, Faker::Finance.credit_card(:mastercard)) if REMOTE.respond_to? "save"
  end

  def ask_for_report(since: Time.now - 1500, to: Time.now, re: /^[a-z].*/i)
    REMOTE.report(since, to, @id, re) if REMOTE.respond_to? "report"
  end
end
