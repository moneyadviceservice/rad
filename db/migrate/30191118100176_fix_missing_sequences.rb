class FixMissingSequences < ActiveRecord::Migration[5.2]
  def self.up
    terms = %w[advisors firms subsidiaries]
    prefixes = %w[lookup_ last_week_lookup_]

    prefixes.each do |prefix|
      terms.each do |term|
        r = execute("SELECT c.relname FROM pg_class c WHERE c.relkind = \'S\' and c.relname = \'#{prefix}#{term.pluralize}_id_seq\' ORDER BY c.relname;")
        if r.count == 0
          execute("CREATE SEQUENCE #{prefix}#{term.pluralize}_id_seq;")
          execute("ALTER TABLE #{prefix}#{term.pluralize} ALTER COLUMN id SET DEFAULT nextval(\'#{prefix}#{term.pluralize}_id_seq\');")
        end
      end
    end
  end
end
