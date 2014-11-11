
import pymongo

from pymongo import MongoClient


# connect to database
connection = MongoClient('localhost', 27017)

db = connection.students

# handle to names collection
grades = db.grades

item = grades.find_one()

db.grades.find({type: "exam", score: {$gte: 65}}, {_id: false}).sort({score: 1})db.grades.find({type: "homework"}).sort({student_id: 1, score: 1})
print item['grade']

