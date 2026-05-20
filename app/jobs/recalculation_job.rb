class RecalculationJob < ApplicationJob
  queue_as :default

  def perform(start_time, end_time)
    # Perform the recalculation logic here
    RecalculationMailer.finished.deliver_later
  end
end
