module Lookup
  class AdvisersController < ApplicationController
    def show
      @adviser = Lookup::Adviser.find_by(reference_number: params[:id])

      if @adviser
        render json: { name: @adviser.name }
      else
        head :not_found
      end
    end
  end
end
