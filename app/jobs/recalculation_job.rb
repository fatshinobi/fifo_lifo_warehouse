class RecalculationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    RecalculationMailer.finished.deliver_later
  end
end
