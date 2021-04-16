# frozen_string_literal: true

json.total_registrations @total_registrations
json.page                @registrations.current_page
json.results_per_page    @registrations.per_page

json.registrations @registrations do |registration|
  json.partial! 'registration', registration: registration
end
