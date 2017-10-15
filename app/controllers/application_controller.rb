class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  respond_to :html

  private

  def self.set_pagination_headers(name, options = {})
    after_action(options) do |controller|
      results = instance_variable_get("@#{name}")
      headers["X-Pagination"] = {
        total_entries: results.total_entries,
        total_pages: results.total_pages,
        current_page: results.current_page,
        first_page: results.current_page == 1,
        last_page: results.next_page.blank?,
        previous_page: results.previous_page,
        next_page: results.next_page,
        offset: results.offset
      }.to_json
    end
  end
end
