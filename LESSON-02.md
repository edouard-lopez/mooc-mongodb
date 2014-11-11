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
