# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
class FakeComment
  def self.create(post, user)
    post.comments.create(
      body: Faker::Hipster.sentence,
      user_id: user.id,
      published_at: Faker::Date.between(1.month.ago, Date.today)
    ) if post && rand(11) < 5
  end
end

10.times do
  george = User.where(
    nickname: Faker::Internet.user_name,
    email: Faker::Internet.free_email,
    password: Faker::Internet.password(5)
  ).create
  bob = User.where(
    nickname: Faker::Internet.user_name,
    email: Faker::Internet.free_email,
    password: Faker::Internet.password(5)
  ).create

  20.times do
    post1 = george.posts.create(
      title: [Faker::Hacker.adjective, Faker::Hacker.noun].join(' ').titleize,
      body: Faker::Hacker.say_something_smart,
      user_id: george.id,
      published_at: Faker::Date.between(1.month.ago, Date.today)
    ) if rand(11) < 5
    post2 = bob.posts.create(
      title: [Faker::Hacker.adjective, Faker::Hacker.noun].join(' ').titleize,
      body: Faker::Hacker.say_something_smart,
      user_id: bob.id,
      published_at: Faker::Date.between(1.month.ago, Date.today)
    ) if rand(11) < 5

    FakeComment.create(post1, bob)
    FakeComment.create(post1, george)
    FakeComment.create(post2, bob)
    FakeComment.create(post2, george)
  end
end
