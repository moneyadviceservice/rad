module Lookup
  class AdvisersController < ApplicationController
    def show
      @adviser = ::Adviser.find_by(reference_number: params[:id])

      if @adviser
        stat :already_matched

        render json: { error: t('questionnaire.adviser.advisers_details.already_exists_error') }, status: 409
      else
        @lookup_adviser = Adviser.find_by(reference_number: params[:id])

        if @lookup_adviser
          stat :matched

          render json: { name: @lookup_adviser.name }
        else
          stat :unmatched

          render json: { error: t('questionnaire.adviser.advisers_details.not_found_error') }, status: 404
        end
      end
    end

    def stat(key)
      Stats.increment("radsignup.adviser.#{key}")
    end
  end
end
