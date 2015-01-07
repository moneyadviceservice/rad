class QuestionnairesController < ApplicationController
  def step_1_form
    @questionnaire = QuestionnaireStep1Form.new
  end
end
