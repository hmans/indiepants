# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  alice = User.create!(name: "Alice", host: "alice.pants.dev")
  bob   = User.create!(name: "Bob",   host: "bob.pants.dev")
  localhost = User.create!(name: "The Host of Local",   host: "localhost")

  FactoryGirl.create :post,
    user: alice,
    body: "Hello world! I'm Alice."

  FactoryGirl.create :post,
    user: bob,
    body: "Hello world! I'm Bob."
end
