module Admin
  module MoveAdvisers
    class ChooseSubsidiaryPage < SitePrism::Page
      set_url_matcher %r{/admin/firms/[0-9]+/move_advisers/choose_subsidiary}

      element :validation_errors, '.t-errors'
      elements :subsidiaries, '.t-subsidiary'
      element :next, '.t-next'

      def subsidiary_field(index)
        subsidiaries[index].find('.t-subsidiary-field')
      end

      def subsidiary_label(index)
        subsidiaries[index].find('.t-subsidiary-label')
      end
    end
  end
end
