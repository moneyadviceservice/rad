module Lookup
  class AdvisersController < PrincipalsBaseController
    def show
      if @adviser = ::Adviser.find_by(reference_number: params[:id])
        errors_for :conflict
      else
        if @lookup_adviser = Adviser.find_by(reference_number: params[:id])
          json_for @lookup_adviser
        else
          errors_for :not_found
        end
      end
    end

    private

    def stat(key)
      Stats.increment("radsignup.adviser.#{key}")
    end

    def json_for(lookup_adviser)
      stat :matched

      render json: { name: lookup_adviser.name }
    end

    def errors_for(status)
      stat stat_key_for(status)

      render json: { error: t("questionnaire.adviser.error_responses.#{status}") }, status: status
    end

    def stat_key_for(status)
      if status == :not_found
        :unmatched
      else
        :already_matched
      end
    end
  end
end
