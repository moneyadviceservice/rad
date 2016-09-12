require 'tempfile'

module River
  module Runners
    class Tempfile
      class << self
        def call(commands, context)
          rd = $stdin
          wr = $stdout
          name = 'River::Command'
          commands.map! do |c|
            wr = ::Tempfile.new(c.object_id.to_s)
            outcome = River::Outcome.new { c.call(rd, wr, context) }
            rd.close unless rd.closed? || (rd == $stdin)
            rewind(wr)
            rd = wr
            context[:logger].info(name) { '* ' }
            outcome
          end
          wr.close unless wr.closed? || (wr == $stdout)
          commands
        end

        private

        def rewind(io)
          io.flush
          io.rewind
        end
      end
    end
  end
end
