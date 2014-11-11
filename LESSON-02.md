# Lesson 02

## Vocabulary

Traditional | MongoDB | SQL |
--------|:--------:|:--------:|
Create  | Insert | Insert
Read  | Find | Select
Update | Update | Update
Delete | Remove | Delete

## BSON

[BSON specification (Binary JSON)](http://bsonspec.org/)

```js
> Number
Number(      NumberInt(   NumberLong(
> NumberInt(2)
NumberInt(2)
> NumberLong(2)
NumberLong(2)
> NumberLong(2)+NumberLong(4)
6
> new Date()
ISODate("2014-11-11T10:52:20.050Z")
```

## Insert document: `insert({…})`

```js
> db.people.insert({"name": "haricot", age: 29})
WriteResult({ "nInserted" : 1 })
> db.people.insert({"name": "yug", age: 30})
WriteResult({ "nInserted" : 1 })
```
Insertion add an extra `_id` key if none is provided. This field is unique and immutable in the collection.

```js
{ "_id" : ObjectId("5461ef9045e2803c66a83e8d"), "name" : "yug", "age" : 30 }
```
ObjectId construction is done as follow: `GID = current_time + UUID + PID + counter`

## Find one document: `findOne()`

Without arguments, `findOne()` returns a random document from collection.

```js
> db.people.findOne()
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "haricot", "age" : 29 }
```

With an (sub-)document as argument returns documents matching given (sub-)document

```js
> db.people.findOne({name: "haricot"})
{
        "_id" : ObjectId("5461ef8545e2803c66a83e8c"),
        "name" : "haricot",
        "age" : 29
}
```

### Select **fields to return** 

Specifying fields to retrieve is done by specifying the second argument:

```js
> db.people.findOne({name: "haricot"}, {age: true})
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "age" : 29 }
> db.people.findOne({name: "haricot"}, {age: true, _id: false})
{ "age" : 29 }
```

## Find document: `find()`

Without arguments, `find()` returns all documents from collection.

```js
> for (i=0; i<1000; i++) { names=["exam", "essay", "quiz"]; for (j=0; j<3; j++) { db.scores.insert({"student": i, "type": names[j], score: Math.round(Math.random()*100)} ); } }
> db.scores.find()
> db.scores.find({student: 19})
```

**Note:** Keep a cursor on results for ~10min.

When specifying multiple critera, the default behavior is a boolean **AND**.

db.scores.find({"type": "essay", "score":50}, {student: true, _id: false})

## Comparison query operators: `$lt` and `$gt` (`$lte` and `$gte`)

Query operators should be provided as a subdocument, with _key_ being the _query operator_ and the _value_ being the 
value to compare agains:  

```js
> // lower than 1
> db.scores.find({type: "essay", score:{ $lt: 1} }) 
{ "_id" : ObjectId("5461f32e051168018d06cccc"), "student" : 27, "type" : "essay", "score" : 0 }
{ "_id" : ObjectId("5461f32f051168018d06cf57"), "student" : 244, "type" : "essay", "score" : 0 }
> // between 40 and 42, without the _id field
> db.scores.find({type: "essay", score:{ $gt: 40, $lt: 42} }, {_id: false})
{ "student" : 16, "type" : "essay", "score" : 41 }
{ "student" : 33, "type" : "essay", "score" : 41 }
```

Also work as lexicographically comparator: 
```js
> // user name starting with letter after 'p' 
> db.people.find({name: {$gt: "p"}}, {_id: false})
{ "name" : "yug", "age" : 30 }
```
**Note:** MongoDB has no locale awareness, it follows UTF-8 code unit byte order.

Operations are strongly and dynamically typed, so even if it schemaless, a lexicographically comparison will be 
limited to document with corresponding field as string. If we insert a new entry to the `people` collection with an 
integer name, neither comparison will return it :
```js
> db.people.insert({"name": 23, age: 20})
> db.people.find({name: {$gt: "p"}}, {_id: false})
{ "name" : "yug", "age" : 30 }
> db.people.find({name: {$lt: "p"}}, {_id: false})
{ "name" : "haricot", "age" : 29 }
```