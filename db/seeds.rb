# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cat.create!(
  name: 'kiki',
  birth_date: '2018-01-20',
  color: 'BLACK',
  sex: 'F',
  description: 'A very cute baby cat!')
  
  Cat.create!(
    name: 'lulu',
    birth_date: '2013-01-20',
    color: 'WHITE',
    sex: 'M',
    description: 'A very arrogant cat!')
    
