
import sys
import pymongo

connection = pymongo.MongoClient("mongodb://localhost")

db = connection.test
users = db.users

doc = {'firstname':'Andrew', 'lastname':'Erlichson'}
print doc
print "about to insert the document"

try:
    users.insert(doc)
except:
    print "insert failed:", sys.exc_info()[0]

# 'insert()' method update the 'doc' object to append an '_id' field, so the 2nd insert attempt
# try insert the same object. To solve this ensure to redifine the 'doc' object
# doc = {'firstname':'Andrew', 'lastname':'Erlichson'}

print doc
print "inserting again"

try:
    users.insert(doc)
except:
    print "second insert failed:", sys.exc_info()[0]

print doc

