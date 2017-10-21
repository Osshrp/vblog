class Api::V1::ReportsController < Api::V1::BaseController

  def by_author
    GenerateReportJob.perform_now(params[:start_date], params[:end_date], params[:email])
    render json: { message: "Report generation started" }
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date, :email)
  end
end
