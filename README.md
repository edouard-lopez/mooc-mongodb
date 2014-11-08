# M101P: MongoDB for Developers

## Lesson 01

[Chapter 1: Introduction](https://university.mongodb.com/courses/10gen/M101P/2014_October/courseware/Chapter_1_Introduction/)

```bash
# run mongo shell
$ mongo
```

## Save an retrieve data

```js
// select database
> use test
// add an entry to collection 'name'
> db.names.save({'name': 'ed8'})

# find all results in collection
> db.names.find()
{ "_id" : ObjectId("545e6c8cfe00f4190ef498ee"), "name" : "ed8" }
```

## Update a data
```js
// find one item and store it in variable 
> var user = db.names.findOne()
// edit variable property 'name'
> user.name = 'Yug'
// save/update value in collection
> db.names.save(user)
```