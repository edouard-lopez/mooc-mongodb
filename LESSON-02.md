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

### Comparison query operators: `$lt` and `$gt` (`$lte` and `$gte`)

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

### Using regexes, `$exists` and `$type`

#### Find document **having fields `f`**:

```js
> db.people.insert({"name": "Eten", age: 20, height: 183})
WriteResult({ "nInserted" : 1 })

> // with field 'height'
> db.people.find({height: {$exists: true} })
{ "_id" : ObjectId("54620f52051168018d06d833"), "name" : "Eten", "age" : 20, "height" : 183 }

> // withOUT field 'height'
> db.people.find({height: {$exists: false} })
{ "_id" : ObjectId("5461eb5b45e2803c66a83e8b"), "a" : 1 }
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "haricot", "age" : 29 }
{ "_id" : ObjectId("5461ef9045e2803c66a83e8d"), "name" : "yug", "age" : 30 }
{ "_id" : ObjectId("54620e37051168018d06d832"), "name" : 23, "age" : 20 }
```

#### Find document with fields of a **given type `t`** 

Where `t` is a numeric value from [BSON type spec](http://bsonspec.org/spec.html): `1` for _integer_, `2` for _string_, etc.

```js
> db.people.find({name: {$type: 1} })
{ "_id" : ObjectId("54620e37051168018d06d832"), "name" : 23, "age" : 20 }
```

#### Find document **matching regex `re`** 

Use PCRE regular expression

```js
> db.people.find({name: {$regex: "[ae]"} })
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "haricot", "age" : 29 }
{ "_id" : ObjectId("54620f52051168018d06d833"), "name" : "Eten", "age" : 20, "height" : 183 }
```

Write a query that retrieves documents from a `people` collection where the name has a `h` in it, and the document has 
an `email` field.

```js
> db.people.find({name: {$regex: "h"}, email: {$exists: true} })
{ "_id" : ObjectId("546211cf051168018d06d834"), "name" : "Charline", "age" : 21, "height" : 182, "email" : "pom@toto.com" }
```

## Boolean operators: `$or` and `$and`
 
### `$or` operator

`$or` is a prefix operator, it takes an array as its value and it come before the sub-queries it connects together. 
Sub-queries are items of that array `$or`. 
array

```js
> db.people.find({$or: [{name: {$regex: "e$"}}, {age: {$exists: true}} ] } )
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "haricot", "age" : 29 }
{ "_id" : ObjectId("5461ef9045e2803c66a83e8d"), "name" : "yug", "age" : 30 }
{ "_id" : ObjectId("54620e37051168018d06d832"), "name" : 23, "age" : 20 }
{ "_id" : ObjectId("54620f52051168018d06d833"), "name" : "Eten", "age" : 20, "height" : 183 }
{ "_id" : ObjectId("546211cf051168018d06d834"), "name" : "Charline", "age" : 21, "height" : 182, "email" : "pom@toto.com" }
```

How would you find all documents in the `scores` collection where the `score` is less than `50` or greater than `90`?

```js
> db.scores.find({$or: [{score: {$lt: 50}}, {score: {$gt: 90}}]})
{ "_id" : ObjectId("5461f32e051168018d06cc7b"), "student" : 0, "type" : "essay", "score" : 24 }
{ "_id" : ObjectId("5461f32e051168018d06cc81"), "student" : 2, "type" : "essay", "score" : 11 }
{ "_id" : ObjectId("5461f32e051168018d06cc82"), "student" : 2, "type" : "quiz", "score" : 7 }
{ "_id" : ObjectId("5461f32e051168018d06cc83"), "student" : 3, "type" : "exam", "score" : 8 }
{ "_id" : ObjectId("5461f32e051168018d06cc84"), "student" : 3, "type" : "essay", "score" : 49 }
…
```

### `$and` operator

Similar to `$or` but less relevant as it's the default boolean operator

```js
> // Careful!
> db.scores.find( { score : { $gt : 50 }, score : { $lt : 60 } } )
> last constraint replace the first one!
```

##  Querying Inside Arrays: `$all` and `$in`

is transparent. There is **no recursion**, mongodb will just look at the top level of the specified field.

```js
> db.accounts.insert({name: "George", favorites: ["ice scream", "pretzels" ]})
WriteResult({ "nInserted" : 1 })
> db.accounts.insert({name: "Howard", favorites: ["pretzels", "beer" ]})
WriteResult({ "nInserted" : 1 })

> db.accounts.find({favorites: "pretzels"})
{ "_id" : ObjectId("54621643c328b9d1f3ad36dd"), "name" : "George", "favorites" : [ "ice scream", "pretzels" ] }
{ "_id" : ObjectId("54621657c328b9d1f3ad36de"), "name" : "Howard", "favorites" : [ "pretzels", "beer" ] }
> db.accounts.find({favorites: "beer"})
{ "_id" : ObjectId("54621657c328b9d1f3ad36de"), "name" : "Howard", "favorites" : [ "pretzels", "beer" ] }
```

### `$all`

Matches all document that **satisfies –at least– all criteria of the `$all`-key object**. Fields order is irrelevant.
 
```js
> db.accounts.find({favorites: {$all: ["pretzels", "beer"] }})
{ "_id" : ObjectId("54621657c328b9d1f3ad36de"), "name" : "Howard", "favorites" : [ "pretzels", "beer" ] }
```

Valid documents can have more fields than the one specified.

### `$in`

Enumeration of all the values we are looking for.

```js
> db.people.find({name: {$in: ["yug", "Eten"] }})
{ "_id" : ObjectId("5461ef9045e2803c66a83e8d"), "name" : "yug", "age" : 30 }
{ "_id" : ObjectId("54620f52051168018d06d833"), "name" : "Eten", "age" : 20, "height" : 183 }
```

## Queries with Dot Notation

To access information un sub-document, simply write the path to it separating level with do (e.g.: `reviews.rating`).

**Note:** In find queries for sub-document **fields order is relevant**, as BSON representations will differ if you 
change order.

```js
> db.catalog.insert({ product : "Super Duper-o-phonic",
    price : 100000000000,
    reviews : [ { user : "fred", comment : "Great!" , rating : 5 },
                { user : "tom" , comment : "I agree with Fred, somewhat!" , rating : 4 } ]
})
WriteResult({ "nInserted" : 1 })
> db.catalog.insert({ product : "Super Duper-o-phonic",
    price : 300000000000,
    reviews : [ { user : "fred", comment : "bouhuoho" , rating : 2 }]
})
```

## Cursor

Allows to programmatically iterate over results.

```js
> cur=db.people.find(); null
null
> cur.hasNext()
true
> cur.next()
{ "_id" : ObjectId("5461eb5b45e2803c66a83e8b"), "a" : 1 }
>
```

* `null` prevent query to be executed ;
* `limit()` limit the number of documents return by query. (Modify information send to server) ;
* `sort()` sort results on given fields and order. (Modify information send to server).
* `skip()` skip `n` results. (Modify information send to server).

```js
> cur=db.people.find().limit(3); null
null
> cur.sort({name: 1});
{ "_id" : ObjectId("5461eb5b45e2803c66a83e8b"), "a" : 1 }
{ "_id" : ObjectId("54620e37051168018d06d832"), "name" : 23, "age" : 20 }
{ "_id" : ObjectId("546211cf051168018d06d834"), "name" : "Charline", "age" : 21, "height" : 182, "email" : "pom@toto.com" }

> cur=db.people.find().limit(3); null
null
> cur.sort({name: -1});
{ "_id" : ObjectId("5461ef9045e2803c66a83e8d"), "name" : "yug", "age" : 30 }
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "haricot", "age" : 29 }
{ "_id" : ObjectId("54620f52051168018d06d833"), "name" : "Eten", "age" : 20, "height" : 183 }
```

 From the `scores` collection retrieves _exam_ documents, sorted by `score` in descending order, skipping the first `50` 
 and showing only the next `20`.
 
```js
> db.scores.find({"type": "exam"}).sort({"score": -1}).skip(50).limit(20)
{ "_id" : ObjectId("5461f330051168018d06d4ba"), "student" : 704, "type" : "exam", "score" : 5 }
{ "_id" : ObjectId("5461f330051168018d06d68b"), "student" : 859, "type" : "exam", "score" : 5 }
{ "_id" : ObjectId("5461f331051168018d06d80e"), "student" : 988, "type" : "exam", "score" : 5 }
{ "_id" : ObjectId("5461f32f051168018d06cda9"), "student" : 101, "type" : "exam", "score" : 6 }
```

##  Counting Results

```js
> db.scores.count()
4181
> db.scores.count({type: "exam"})
1000
```

Count the documents in the `scores` collection where the `type` was _essay_ and the `score` was greater than `90`?

```js
> db.scores.count({type: "essay", score: {$gt: 90}})
100
```

## Updating of a Document

First argument is same as in `find()`. Second argument is the document used to replace existing content (existing 
data may be discarded).
 
**Note:** Non-specified **fields will be removed!**.
  
```js
> db.people.update({"name" : "haricot"})
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "haricot", "age" : 29 }

> // change first letter of the name
> db.people.update({"name" : "haricot"}, {"name" : "Haricot"})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

// age field has been removed!
> db.people.update({"name" : "haricot"})
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "Haricot" }
```

### `$set` Command
 
Update or create fields, **conserving other fields**.

```js
> db.people.update({"name" : "Haricot"}, {$set: {"age" : 29}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

// age has been restored
> db.people.find({name: "Haricot"})
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "Haricot", "age" : 29 }
```

### `$inc` Command

Increment an existing fields by the given amount. If the fields doesn't exists it is created with the `$inc` 
value.

```js
> db.people.update({"name" : "Haricot"}, {$inc: {"age" : -2}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.people.find({name: "Haricot"})
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "Haricot", "age" : 27 }
```

> db.users.insert({ "_id" : "myrnarackham", "phone" : "301-512-7434", "country" : "US" })
WriteResult({ "nInserted" : 1 })
> db.users.update({_id: "myrnarackham"}, {$set: {country: "RU"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

### `$unset` Command

Remove fields

```js
> db.users.update({_id: whatever}, {$unset: {fieldstoremoe: 1}} )
```

### Using `$push`, `$pop`, `$pull`, `$pushAll`, `$pullAll`, `$addToSet`

`$push` add ;
`$pop` remove by index ;
`$pull` remove a value from array ;
`$pushAll` add several elements (e.g. `… {$pushAll: {a: [ 5, 6, 7 ]} …`
`$pullAll`, remove several values
`$addToSet`

## Upserts

Update or create an object

```js
db.users.update({name: "George"}, { $set: {age: 40}}, { upsert: true })
WriteResult({
        "nMatched" : 0,
        "nUpserted" : 1,
        "nModified" : 0,
        "_id" : ObjectId("54622845dcfb94bfdb97a822")
})
``````

##  Multi-update

Use `{}` as object matching and `{multi: true}` option to update all.

```js
> // add a "country" fields to all document
> db.people.update({}, {$set: {country: "FR"}}, {multi: true})
WriteResult({ "nMatched" : 7, "nUpserted" : 0, "nModified" : 7 })

> db.people.find()
{ "_id" : ObjectId("5461ef8545e2803c66a83e8c"), "name" : "Haricot", "age" : 27, "country" : "FR" }
{ "_id" : ObjectId("5461ef9045e2803c66a83e8d"), "name" : "yug", "age" : 30, "country" : "FR" }
```

**Note:** document removal is atomic
**Note:** multi-document removal is not atomic.
