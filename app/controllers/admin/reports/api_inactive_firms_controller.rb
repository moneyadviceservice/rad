module Admin
  module Reports
    class ApiInactiveFirmsController < Admin::ApplicationController
      def index
        if params[:type] == 'travel'
          @inactive_firms = InactiveFirm.travel.preload(firmable: [:office])
        else
          @inactive_firms = InactiveFirm.retirement.preload(firmable: [:offices, :advisers])
        end

        @latest_timestamp = @inactive_firms.maximum(:created_at)
      end
    end
  end
end
