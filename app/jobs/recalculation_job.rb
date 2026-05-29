class RecalculationJob < ApplicationJob
  queue_as :default

  def perform(start_time, end_time)
    RecalculationProcess.call(start_time, end_time)
    RecalculationMailer.finished.deliver_later
  end
end
