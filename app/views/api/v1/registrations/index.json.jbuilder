json.registrations @registrations do |registration|
  json.partial! 'registration', registration: registration
end