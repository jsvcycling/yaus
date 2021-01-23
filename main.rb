require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'securerandom'

require_relative 'link'

rom = ROM.container(:sql, 'sqlite://db/database.sqlite3') do |conf|
  conf.register_relation(Links)
end

links_repo = LinksRepo.new(rom)

get '/' do
  erb :index
end

post '/create' do
  # Check if a link already exists for the target.
  target = JSON.parse(request.body.read)['target']
  halt 400 if target.empty?

  link = links_repo.find_by_target(target)
  json slug: link.slug unless link.nil?
  
  # The target has never been seen before. Create a new link.
  slug = SecureRandom.alphanumeric(8)

  link = links_repo.create(slug: slug, target: target)
  halt 500 if link.nil?

  json slug: slug
end

get '/*' do
  slug = params['splat'][0]
  link = links_repo.find_by_slug(slug)

  halt 404, erb(:not_found) if link.nil?

  redirect link.target, 308
end
