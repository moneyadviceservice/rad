# Customisation for the Ransack Gem
Ransack.configure do |config|
  PG_EMPTY_ARRAY = '{}'.freeze

  # Custom predicates.
  # See: https://github.com/activerecord-hackery/ransack/wiki/Custom-Predicates

  # Ransack does not support predicates for PostgreSQL array fields by default.
  # This defines a custom predicate that allows us to put a checkbox on the
  # Ransack based forms in the admin area, that when checked returns all
  # records with a non-empty array field.
  #
  # E.g. on the form definition we can specifiy
  #
  # ```
  # <%= f.check_box :languages_array_present %>
  # ```
  config.add_predicate('array_present', {
    # Specify what non-compound ARel predicate to use.
    #
    # We want to say != '{}' so we use the not_eq predicate
    arel_predicate: Ransack::Constants::NOT_EQ,

    # Format incoming values from the form.
    #
    # We always want to compare the field with the PG empty array constant so
    # we ignore the actual value from the form and return PG_EMPTY_ARRAY
    formatter: proc { |_v| PG_EMPTY_ARRAY },

    # Validate a value. An "invalid" value won't be used in a search.
    #
    # We only want this filter to be active when the checkbox is checked so we
    # only consider 'true' values as valid.
    validator: proc { |v| Ransack::Constants::TRUE_VALUES.include?(v) },

    # Should compounds be created? Will use the compound (any/all) version
    # of the arel_predicate to create a corresponding any/all version of
    # your predicate. (Default: true)
    #
    # We don't accept multiple values so setting this to false.
    compounds: false,
  })
end
