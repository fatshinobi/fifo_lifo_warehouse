class EventsController < ApplicationController
  # No view templates are required for this controller.
  # The create action processes the incoming :action parameter and
  # performs different logic based on its value.
  def create
    # Fetch the custom action parameter. In Rails the name :action is used
    # internally for the controller action name, so we access it via
    # params[:event_action] which will contain the value sent by the client.
    custom_action = params[:event_action]

    case custom_action
    when "recalculation"
      RecalculationJob.perform_later
      head :ok
    else
      # Unknown action – respond with bad request
      render json: { error: "Unsupported action: #{custom_action}" }, status: :bad_request
    end
  end
end
