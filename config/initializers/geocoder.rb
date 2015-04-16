# Heroku requires an http proxy to make API calls.
# Set geocoder to use quotaguard.

if Rails.env.production?
  Geocoder.configure(
    :http_proxy => ENV['QUOTAGUARD_URL'],
    :timeout => 5
  )
end