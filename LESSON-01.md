# M101P: MongoDB for Developers

# Lesson 01

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
```
**Note**: you need to quote string values.

# find all results in collection

```js
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
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
```

## Schemaless

* Different documents can have differents schemas
* play nicely with Agile project

```js
# add document to new 'users' collection
> db.users.insert({name: 'ed8', city_of_birth: 'some place'})
WriteResult({ "nInserted" : 1 })

# pretty print
> db.users.find().pretty()
{
        "_id" : ObjectId("545e919afe00f4190ef498ef"),
        "name" : "ed8",
        "city_of_birth" : "some place"
}

# add a different object to this collection (extra field 'age')
> db.users.insert({name: 'yug', city_of_birth: 'other place', age: 22})
WriteResult({ "nInserted" : 1 })

# update legacy to add extra field
> var user = db.user.findOne({"name" : "ed8"})
> user.age = 28
28
> db.user.save(user)
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
# check user has new field
> db.users.find().pretty()
```

**Note:** remove item
```
# remote by id
> db.users.remove({"_id" : ObjectId("545e919afe00f4190ef498ef")})
WriteResult({ "nRemoved" : 1 })
```

## JSON Revisited

* arrays: `[ … ]` ;
* dictionaries: `{ key: value …}`.


## Blog

### Relational model
* `posts`
    * `post_id`
    * `author_id`
    * `title`
    * `post`
    * `date`
* `comments`
    * `comment_id`
    * `name`
    * `comment`
    * `email`
* `tags`
    * `tag_id`
    * `name`
* `authors`
    * `author_id`
    * `username`
    * `password`
* `post_tags` (m2m relation)
* `post_comments` (m2m relation)

### NoSQL/MongoDB model

* _posts_ collection

```json
{
  title: "My super title",
  body: "Content of my post",
  author: "ed8",
  date: "11/11/11",
  comments: [
    {
      name: 'Yug',
      email: 'yug@ma.il',
      comment: 'content of the comment'
    },
    {…}
  ],
  tags: [
    'agile',
    'gulp',
    'tdd'
  ]
}
```

* _authors_ collection

```json
{_id: 'ed8', password: 'sup3r_s3cr3t'}
```

### Schema Design: to Embed or not to embed ?

Should we embed `tags` and `comments` inside the `posts` collection? You can decide by answering the following 
question: _"does I access them more often independently or together?"_
The important is how do you access the data.

* **Note:** Documents are **limited to 16Mb**.
* **Note:** Indexing can be done on sub-document, so **index doesn't require to create an extra table**.


## Python

### Lists

Are 0-indexed in python.
```python
>>> my_list = [1, 2, 3, ["aa", "bb"] ]
>>> my_list[0]
1
```
* slices are defined by a starting index, which is included, and an **ending index that is excluded**:
 ```python
my_list = [1, 2, 3, ["aa", "bb"] ]
>>> my_list[1:3]
[2,3]
```
 * short-hand:
  * without ending `[2:]`, return from index _2_ to the end of the list  
  * without starting [:5], return from the beginning up to the index `5`-1. 
  * `[:]` return whole list.
  
### Dictionaries

Are not ordered like the lists, so item may be listed in different way each time.
```python
>>> my_dico = {"city": "paris", "age": 23}
>>> my_dico.city
"paris"
>>> del(my_dico["city"])  # key need to exist

>>> colors = {'sky':'blue', 'sea':'blue', 'earth':'brown'}
>>> 'sky' in colors
True
```

## Homework

```js
> use m101
> show collections
```
