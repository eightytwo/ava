unless Rails.env.production?
  ENV['AVA_VIMEO_CONSUMER_KEY'] = ""
  ENV['AVA_VIMEO_CONSUMER_SECRET'] = ""
  ENV['AVA_VIMEO_TOKEN'] = ""
  ENV['AVA_VIMEO_TOKEN_SECRET'] = ""
end
