module Lookup
  class AdvisersController < ApplicationController
    def show
      @adviser = Lookup::Adviser.find_by(reference_number: params[:id])

      if @adviser
        Stats.increment('radsignup.adviser.matched')

        render json: { name: @adviser.name }
      else
        Stats.increment('radsignup.adviser.unmatched')

        head :not_found
      end
    end
  end
end
