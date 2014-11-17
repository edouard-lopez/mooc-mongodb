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

