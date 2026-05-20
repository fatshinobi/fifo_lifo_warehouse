class RecalculationsEventsController < EventsController
  # Inherits the create action from EventsController.
  # The new action renders a form that posts to the create action of EventsController.
  def new
    @start_time = Time.current.beginning_of_month
    @end_time = Time.current.end_of_day
  end
end
