module Admin
  module Reports
    class ApiInactiveFirmsController < Admin::ApplicationController
      def index
        @inactive_firms =
          InactiveFirm
          .includes(:firm)
          .order('firms.registered_name ASC')
        @latest_timestamp = @inactive_firms.maximum(:created_at)
      end
    end
  end
end
