module FcaApiExtractCreds
  def set_env_for_api_calls
    extract_fca_vars_from_dot_env.each { |name, value| set_env_var(name, value) }
  end

  def set_env_var(name, value)
    allow(ENV).to receive(:fetch).with(name).and_return(value)
  end

  def extract_fca_vars_from_dot_env
    File.readlines('.env').each_with_object({}) do |line, api_params|
      key, value = line.chomp.split('=')

      value = value.gsub(/^'|'$/, '')

      api_params[key] = value if key.start_with?('FCA_API')

      api_params
    end
  end
end
