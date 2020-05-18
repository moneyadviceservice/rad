require 'spec_helper'

RSpec.describe TravelInsuranceRegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  it 'should have overriden admin email address' do
    expect(subject.admin_email_address).to eq(ENV['TAD_ADMIN_EMAIL'])
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        new_principal_form: {
          fca_number: '123456',
          first_name: 'Insurance',
          last_name: 'Advisor',
          job_title: 'Insurer',
          email: 'email@email.com',
          telephone_number: '02089765432',
          password: 'Password1!',
          password_confirmation: 'Password1!',
          confirmed_disclaimer: 1,
          registration_type: :travel_insurance_registrations
        }
      }
    end

    it 'stores submitted params in session' do
      post :create, params: valid_params
      expect(session[:principal]).not_to be_nil
      expect(session[:principal][:fca_number]).to eq('123456')
    end

    it 'redirects to next signup page' do
      post :create, params: valid_params
      expect(response).to redirect_to(risk_profile_travel_insurance_registrations_path)
    end
  end

  describe 'GET #rejection_form' do
    it 'renders successfully' do
      get :rejection_form
      expect(response).to be_successful
    end

    it 'calls Stats.increment when rejection page is loaded' do
      expect(Stats).to receive(:increment).with('tadsignup.prequalification.rejection')
      get :rejection_form
    end
  end

  describe 'GET #wizard_form' do
    it 'is successful for :risk_profile step' do
      get :wizard_form, params: { current_step: 'risk_profile' }
      expect(response).to be_successful
    end

    it 'is successful for :medical_conditions step' do
      get :wizard_form, params: { current_step: 'medical_conditions' }
      expect(response).to be_successful
    end
  end

  describe 'POST #wizard as risk_profile' do
    context 'when allowed to continue' do
      it 'redirects to the next step when allowed to continue' do
        post :wizard, params: { current_step: :risk_profile, travel_insurance_risk_profile_form: { covered_by_ombudsman_question: 'true', risk_profile_approach_question: 'questionaire' } }
        expect(response).to redirect_to medical_conditions_travel_insurance_registrations_path
      end
    end

    context 'when not qualified' do
      it 'redirects to reject page' do
        post :wizard, params: { current_step: :risk_profile, travel_insurance_risk_profile_form: { covered_by_ombudsman_question: 'true', risk_profile_approach_question: 'neither' } }
        expect(response).to redirect_to reject_travel_insurance_registrations_path
      end
    end
  end
end
