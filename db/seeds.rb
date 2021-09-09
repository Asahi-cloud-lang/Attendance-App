# coding: utf-8

User.create!(name: "上長A",
             email: "sample@email.com",
             uid: 1,
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: true)

User.create!(name: "上長B",
             email: "test@email.com",
             uid: 2,
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: true)
             
User.create!(name: "上長C",
             email: "test2@email.com",
             uid: 3,
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: true)
             
Base.create!(name: "拠点A")

Base.create!(name: "拠点B")

Base.create!(name: "拠点C")


60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  base_id = "#{rand(1..3)}"
  User.create!(name: name,
               email: email,
               base_id: base_id, 
               password: password,
               password_confirmation: password)
end