module Admin
  class MoveAdvisersController < Admin::ApplicationController
    before_action :assign_form

    def new
    end

    def choose_destination_firm
      if @form.invalid?
        render :new
      end
    end

    def choose_subsidiary
      @form.validate_destination_firm_fca_number = true

      if @form.invalid?
        render :choose_destination_firm
      end
    end

    def confirm
      @form.validate_destination_firm_fca_number = true
      @form.validate_destination_firm_id = true

      if @form.invalid?
        render :choose_subsidiary
      end
    end

    def move
      @form.validate_destination_firm_id = true

      if @form.valid?
        @form.advisers_to_move.move_all_to_firm(@form.destination_firm)
      else
        fail 'Form data is invalid'
      end
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
                  adviser_ids: []))
    end
  end
end
