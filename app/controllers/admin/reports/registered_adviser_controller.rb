module Admin
  module Reports
    class RegisteredAdviserController < Admin::ApplicationController
      def index
        @registered_advisers = Adviser.all.page(params[:page])

        respond_to do |format|
          format.html
          format.csv
        end
      end
    end
  end
end
