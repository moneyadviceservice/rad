module Lookup
  class AdvisersController < ApplicationController
    def show
      @adviser = Lookup::Adviser.find_by(reference_number: params[:id])

      render json: { name: @adviser.name }
    end
  end
end
