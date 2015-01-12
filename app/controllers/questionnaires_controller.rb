class QuestionnairesController < ApplicationController
  def step_one_form
    @questionnaire = QuestionnaireStepOneForm.new
  end
end
