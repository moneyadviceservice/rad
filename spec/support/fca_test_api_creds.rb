module FcaTestApiCreds
  def set_env_for_api_calls
    extract_fca_vars_from_dot_env.each {|name, value| set_env_var(name, value) }
  end

  def set_env_var(name, value)
    allow(ENV).to receive(:fetch).with(name).and_return(value)
  end

  def extract_fca_vars_from_dot_env
    File.readlines('.env').inject Hash.new do |acca, line|
      key, value = line.chomp.split('=')

      value = value.gsub(/^'|'$/, '')

      acca[key] = value if key.start_with?('FCA_API')

      acca
    end
  end
end
