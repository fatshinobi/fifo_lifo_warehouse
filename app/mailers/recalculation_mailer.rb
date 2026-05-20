class RecalculationMailer < ApplicationMailer
  # Sends a simple notification email when a recalculation finishes.
  # The recipient address is taken from the ENV variable NOTIFY_EMAIL.
  def finished
    @message = "Recalculation finished"
    mail(to: ENV.fetch("NOTIFY_EMAIL", ENV.fetch("ADMIN_EMAIL", "admin@example.com")), subject: "Recalculation Complete")
  end
end
