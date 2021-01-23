require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'securerandom'
require 'sqlite3'

db = SQLite3::Database.new 'database.db'

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS links (
  id TEXT PRIMARY KEY NOT NULL,
  target TEXT NOT NULL UNIQUE
);
SQL

get '/' do
  erb :index
end

post '/create' do
  target = JSON.parse(request.body.read)['target']
  halt 400 if target.empty?

  # Check if a link already exists for the target.
  slug = db.get_first_value('SELECT id FROM links WHERE target = ?', target)
  return json slug: slug unless slug.nil?

  # The target has never been seen before. Create a new link.
  slug = SecureRandom.alphanumeric(8)

  link = db.execute('INSERT INTO links VALUES (?, ?)', slug, target)
  halt 500 if link.nil?

  json slug: slug
end

get '/*' do
  slug = params['splat'][0]
  target = db.get_first_value('SELECT target FROM links WHERE id = ?', slug)

  halt 404, erb(:not_found) if target.nil?

  redirect target, 308
end
