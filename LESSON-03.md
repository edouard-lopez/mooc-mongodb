# M101P: MongoDB for Developers

# Lesson 03

* What pieces of data are **used together** ?
* What pieces  of data are **used read-only** ?
* What pieces  of data are **written all the time** ?


 ## MongoDB Schema Design
 
**Design goal:** match data access patterns of your application.

* rich documents (array, objects, etc.) ;
* this allow pre-join/embed data ;
* no join per-se so think how your app will be used ;
* no constraints (no FK → embed) ;
* possible atomic operation (if needed) ;
* no _declared_ schema, but possible schema as _similar_ structure.

## Relational Normalization

Relational models approach aim to:
 
* free databse from mofication anomalies/inconsistencies ← we will avoid duplication of data ;
* minimize re-design when extending ;
* **avoid biais toward any particular access pattern** ← MongoDB is **tuned** toward access pattern.

## Mongo Design for Blog

Blog post entry:

```js
{
  "_id": ObjectId("…"),
  "author": "<string>",
  "body": "<string>",
  "comments": [
    {
      "body": "<string>",
      "email": "<string>",
      "author": "<string>"
    },
    …
  ],
  "date": ISODate("…"),
  "permalink": "<string>",
  "tags": [
    "<string>",
    "<string>",
    "<string>"
  ],
  "title": "<string>"
}
```

User entry:
```js
{
    "_id": "<string>",
    "password": "<string>"
}
```

* Collecting most recent blog entry would be done by a `sort()` by date and a `limit()` ;
* Collecting all the information to display a signle post is super simple as each object is a blog post ;
* Collect all comment by a single author if you had an index on `comments.author` 
* Not really suitable to provide a table of contents by tag. Possible through the aggregation framework.


## Alternative Schema for Blog

Alternative design could be, a collection for each:

* `post` ;
* `comments` with an extra field `post_id` and a field to preserve `order` ;
* `tags` with an extra field `post_id`,

That look like a relational design approach which may indicate **a wrong design for MongoDB**. Prefer to embed data 
where you can, or pre-join it.
 
## Living Without Constraints

Relational is good a keeping data consistant in the database (cf. Foreign Key constraint). In MongoDB, there is no 
such guarantee, you must code it or… embed data!

Embedding data intrinsically provide consistency.

## Living Without Transactions

MongoDB has atomic operations (view all or none). There is no need to modify multiple tables when everything is 
embedded. Hence the importance of embedding. So there is several approach:

1. restructure to have a single document to leverage atomicity ;
2. implement safe writing or whatever in your code (bof bof) ;
3. tolerate a bit of inconsistency (no need to be perfectly in-sync).

Following operations are atomic in MongoDB: `update`, `findAndModify`, `$addToSet` (within update), `$push` (within 
update) update) 

## One to One Relations

Straight-forward modeling in MongoDB (Employee 1:1 Resume)

* consider how you are going to access your data ? Encourage embedding or not ;

Why keep related document in separate collection ?

* are you accessing/updating some part really often ? So it might be better to split to reduce working set size of your app ;
* if one document is > 16Mb you won't be able to embed
