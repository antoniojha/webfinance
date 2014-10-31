# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Bank.delete_all
Bank.create!(
    id: 13041,
    content_service_id: 3190,
    content_service_display_name: '1st Bank (US)',
    site_id: 3048,
    site_display_name: '1st Bank (US)',
    mfa: 'none',
    home_url: 'http://www.efirstbank.com/',
    container: 'bank'
  )