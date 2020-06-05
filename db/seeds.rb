# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
questions = Question.create([{title: 'Ultimate question', body: 'About life, universe and everything'},
                             {title: 'Poor Yorick', body: 'Tobe or not to be'}])
answers = Answer.create([{body: '42', question_id: questions[0].id},
                         {body: 'to be', question_id: questions[1].id},
                         {body: 'not to be', question_id: questions[1].id}])