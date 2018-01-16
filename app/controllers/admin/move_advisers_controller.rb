module Admin
  class MoveAdvisersController < Admin::ApplicationController
    before_action :assign_form

    def new; end

    def choose_destination_firm
      render :new if @form.invalid?
    end

    def choose_subsidiary
      @form.validate_destination_firm_fca_number = true

      render :choose_destination_firm if @form.invalid?
    end

    def confirm
      @form.validate_destination_firm_fca_number = true
      @form.validate_destination_firm_id = true

      render :choose_subsidiary if @form.invalid?
    end

    def move
      @form.validate_destination_firm_id = true
      raise 'Form data is invalid' unless @form.valid?

      @form.advisers_to_move.move_all_to_firm(@form.destination_firm)
    end

    private

    def assign_form
      @form = Admin::MoveAdvisersForm.new(flattened_params)
    end

    def flattened_params
      # We take the `id` from the top tier of the params then extract the rest
      # of the fields from the `admin_move_advisers_form` hash so there's no
      # nesting.
      params.permit(:id).merge(
        params.fetch(:admin_move_advisers_form, {})
          .permit(:destination_firm_fca_number,
                  :destination_firm_id,
                  adviser_ids: [])
      )
    end
  end
end
