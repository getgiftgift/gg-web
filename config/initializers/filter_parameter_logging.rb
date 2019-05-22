# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
# The :account, :name and :cvv2 params are filtered for PCI compliance
Rails.application.config.filter_parameters += [:password, :account, :name, :cvv2]
