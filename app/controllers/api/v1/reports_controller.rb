class Api::V1::ReportsController < Api::V1::BaseController

  def by_author
    User.generate_and_send_report(params[:start_date], params[:end_date], params[:email])
    render json: { message: "Report generation started" }
  end
end
