module Admin
  module Reports
    class RegisteredAdviserController < Admin::ApplicationController
      respond_to :html, :csv

      def index
        advisers = Adviser.includes(:qualifications, :accreditations).all

        @registered_advisers = advisers.page(params[:page])
        @registered_advisers_list = AdviserListCsv.new(advisers)

        respond_with(@registered_advisers_list, filename: filename)
      end

      private

      def filename
        "registered_advisers_#{Time.zone.today}"
      end
    end
  end
end
