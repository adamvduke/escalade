# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

site = user.sites.find_or_create_by(
  name: 'adamvduke.com',
  domain_name: 'adamvduke.com',
  vcs_url: 'https://github.com/adamvduke/adamvduke.github.com.git',
  build_type: 'jekyll'
)

SiteGeneratorWorker.perform_async(site.id)

site = user.sites.find_or_create_by(
  name: 'alfather.com',
  domain_name: 'alfather.com',
  vcs_url: 'https://github.com/alfather/alfather.github.io.git',
  build_type: 'jekyll'
)

SiteGeneratorWorker.perform_async(site.id)
