# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  alice = Pants::User.local.create!(name: "Alice", host: "alice.pants.dev", password: "secret")
  bob   = Pants::User.local.create!(name: "Bob",   host: "bob.pants.dev", password: "secret")
  localhost = Pants::User.local.create!(name: "The Host of Local", host: "localhost", password: "secret")

  Pants::Post.create! user: alice, body: "This is a beautiful **Markdown-formatted** article."
  Pants::Document.create!    user: alice, html: "<p>This is a post from an outside source (or from an unknown post type.) It comes with HTML that is hopefully sanitized.</p>"
  Pants::Post.create! user: alice, body: "Hi, I'm Alice! \o/"

  bobs_post = Pants::Post.create! user: bob, body: "Hello, I am Bob."

  Pants::Post.create! user: alice, body: "I like linking to www.planetcrap.com. I also like Bob, and linking to [his posts](#{bobs_post.url}). Yay!"
end
