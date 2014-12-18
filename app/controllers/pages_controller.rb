class PagesController < ApplicationController
  before_action :authenticate, except: [:error]

  def error
  end
end
