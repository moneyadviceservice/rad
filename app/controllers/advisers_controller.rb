class AdvisersController < ApplicationController
  def new
    @adviser = Adviser.new
  end
end

Adviser = Class.new do
  include ActiveModel::Model

  attr_accessor :reference_number
end
