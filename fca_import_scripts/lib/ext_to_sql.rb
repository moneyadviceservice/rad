require 'date'
require 'set'
require 'yaml'

require_relative 'importers/firm_importer'
require_relative 'importers/subsidiary_importer'
require_relative 'importers/adviser_importer'
require_relative 'importers/columns'

class ExtToSql
  TIMESTAMP = Time.now.strftime('%Y-%m-%d %H:%M:%S.%N') # rubocop:disable Rails/TimeZone
  REPAIR_FILE = File.join(File.dirname(__FILE__), '..', 'repairs.yml')

  def initialize(zip_file_contents, stderr = nil)
    @stderr = stderr
    @zip_file_contents = zip_file_contents
    @type_importer = find_type zip_file_contents
  end

  def truncate_and_copy_sql
    truncate + copy
  end

  def process_ext_file_content(&block)
    @zip_file_contents.split("\n").each do |line|
      line = repair_line line
      row = line.split('|')

      next if row.first == 'Header' || row.first == 'Footer'

      block.call build_row(row) if @type_importer.record_active? row
    end
  end

  private

  def truncate
    "TRUNCATE #{@type_importer.table_name};"
  end

  def copy
    @type_importer.copy
  end

  def find_type(content)
    header_row = content.split("\n").first
    row = header_row.split('|')
    determine_type_from_header(row)
  end

  def determine_type_from_header(row)
    header = row[Importers::COLUMNS::HEADER_NAME]
    importers = [Importers::AdviserImporter.new, Importers::FirmImporter.new, Importers::SubsidiaryImporter.new]
    importer = importers.find { |klass| klass.can_process? header }

    fail "Unable to determine file type from header: #{row[Importers::COLUMNS::HEADER_NAME]}" if importer.nil?

    importer
  end

  def build_row(row)
    number = row[Importers::COLUMNS::REFERENCE_NUMBER] # reference number for advisers or firms
    name = escape(row[Importers::COLUMNS::NAME].strip)

    "#{number}\t#{name}\t#{TIMESTAMP}\t#{TIMESTAMP}"
  end

  def repairs
    @fixes ||= YAML.load_file(REPAIR_FILE)['repairs']
  end

  def repair_line(line)
    line = line.strip
    match = repairs.find { |pair| line == pair['line'] }
    if match.nil?
      warn_on_possibly_broken_line line
      line
    else
      match['replacement']
    end
  end

  def warn_on_possibly_broken_line(line)
    return unless line.include? '""'
    log "\n  • \033[33;31mPossibly malformed row detected:\033[0m #{line}\n    ", newline: false
  end

  def escape(str)
    str.gsub("\t", '\t').gsub("'", "''")
  end

  def log(str, newline: true)
    return if @stderr.nil?
    if newline
      @stderr.puts str
    else
      @stderr.print str
      @stderr.flush
    end
  end
end
