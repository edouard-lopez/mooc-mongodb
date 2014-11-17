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

