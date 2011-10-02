Factory.define :user do |user|
  user.name                   "Sample User"
  user.email                  "sample@example.com"
  user.password               "samplepass"
  user.password_confirmation  "samplepass"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :folder do |folder|
  folder.name "New Parent Folder"
  folder.association :user
end
