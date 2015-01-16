class QuestionnairesController < ApplicationController
  def new
    @lookup_firm = current_user.firm
    @firm = Firm.new
  end
end
