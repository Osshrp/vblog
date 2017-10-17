class Api::V1::ReportsController < ApplicationController

  def by_author
    GenerateReportJob.perform_later(report_params.to_h)
    respond_with(message: 'Report generation started')
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date, :email)
  end
end
