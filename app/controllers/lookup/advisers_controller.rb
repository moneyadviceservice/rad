module Lookup
  class AdvisersController < ApplicationController
    def show
      @adviser = ::Adviser.find_by(reference_number: params[:id])

      if @adviser
        stat :already_matched

        render json: { error: t('questionnaire.adviser.error_responses.already_exists') }, status: 409
      else
        @lookup_adviser = Adviser.find_by(reference_number: params[:id])

        if @lookup_adviser
          stat :matched

          render json: { name: @lookup_adviser.name }
        else
          stat :unmatched

          render json: { error: t('questionnaire.adviser.error_responses.not_found') }, status: 404
        end
      end
    end

    def stat(key)
      Stats.increment("radsignup.adviser.#{key}")
    end
  end
end
