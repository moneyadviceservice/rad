class PagesController < ApplicationController
  before_action :load_principle, except: [:error]

  def error
  end
end
