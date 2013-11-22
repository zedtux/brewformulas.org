# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
if secret_key_base = AppConfig.secret_key_base rescue nil
  Rails.logger.info "Using production secret_key_base"
else
  Rails.logger.info "Using default secret_key_base"
end
secret_key_base = "552573ba7d00afb0b67dad7532bb78b7492e02f1573011c15fd4f5b979ec266932c6b13b42c146eec993284a1124eb288334b58d8362f9b8a5ec47ac5b0d2e63" unless secret_key_base
BrewformulasOrg::Application.config.secret_key_base = secret_key_base
