class AdvisersController < ApplicationController
  def new
    @adviser = Adviser.new
  end
end
