# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'charles@dev.com', first_name: 'charles')
User.create(email: 'rilke@dev.com', first_name: 'rilke')
maths = User.first.decks.create(name: 'maths')
User.first.decks.create(name: 'git commands')
maths.cards.create(question: 'addition?', answer_1: '1+1', answer_2:'2*2', answer_3: '3!', answer_4: '3-2')
maths.cards.create(question: 'which one is true in the computer science?', answer_1: 'false', answer_2:'3 == 2', answer_3: '2 != 2', answer_4: 'pi')
