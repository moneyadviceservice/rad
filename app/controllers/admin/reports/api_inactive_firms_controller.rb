module Admin
  module Reports
    class ApiInactiveFirmsController < Admin::ApplicationController
      def index
        @inactive_firms = if params[:type] == 'travel'
                            InactiveFirm.travel.preload(firmable: [:office])
                          else
                            InactiveFirm.retirement.preload(firmable: [:offices, :advisers])
                          end

        @latest_timestamp = @inactive_firms.maximum(:created_at)
      end
    end
  end
end
