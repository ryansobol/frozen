## Frozen v0.1.0 (Not yet released)

**Frozen** provides immutable entities and collections for Node and browser apps.

- The README
- The wiki
- The article(s)
- The issue tracker
- The stackoverflow page
- The twitter account

The MIT license - Copyright (c) 2014 [Kurbo Health](http://kurbo.com/) - Author [Ryan Sobol](http://ryansobol.com)


## Example

```coffee
princess = new Frozen.Entity({ name: 'Anna' })
princess.get('name')  
#=> 'Anna'

princess.set({ trait: 'adorkable' })
#=> new Frozen.Entity({ name: 'Anna', trait: 'adorkable' })

princess.set({ name: 'Elsa' })
#=> new Frozen.Entity({ name: 'Elsa' })

princess.get('name')
#=> 'Anna'
```

```coffee
royals = new Frozen.Collection({ name: 'Elsa' })
royals.at(0)
#=> Frozen.Entity({ name: 'Elsa' })

royals.push({name: 'Anna'})
#=> new Frozen.Collection([{ name: 'Elsa' }, { name: 'Anna' }])

royals.change(0, { name: 'Snow Queen' })
#=> new Frozen.Collection({ name: 'Snow Queen' })

royals.remove(0)
#=> new Frozen.Collection()

royals.at(0)
#=> Frozen.Entity({ name: 'Elsa' })
```

## Introduction

I wrote Frozen for two reasons -- faster React performance and faster development time.

[INSERT RATIONALE FOR IMMUTABLE DATA STRUCTURES WITH REACT]

[INSERT RATIONALE ON BACKBONE'S DATA MODELING]

[INSERT RATIONALE ON GARY BERNHARDT'S IMMUTABLE CORE, IMPERATIVE SHELL]

While it's probably not bug free, Frozen has a comprehensive test suite. I'm using Frozen in a production environment without any issues.

Please be aware that Frozen is pre-1.0 software. This means function signatures or behavior may change. If a breaking change is necessary, I'll be sure to give a deprecation warning that includes a fix and when the feature will be removed.


## Contributing

There are a bunch of Backbone features that I'd like to see ported over. If you create a fork, please consider submitting a pull request.

In your pull request, please make a strong case as to why the changes are necessary.  Providing example code and tests significantly increases the chances your pull request is accepted.


## Frozen.Entity

Instances of **Frozen.Entity** represent a single object in an application's state. They are composed of two immutable properties -- key-value **attributes** and validation **errors**. They also have APIs for:

- Constructing new entities from an existing one
- Retrieving a single attribute from within an entity
- Converting an entity to JSON

A subclass extends **Frozen.Entity** with domain-specific validation rules, associated attributes, computed properties, etc.

```coffee
class Profile extends Frozen.Entity

class User extends Frozen.Entity
  associations:
    profile: Profile

  validations:
    name:
      required: true

  title: ->
    "#{@get('name')} the #{@get('profile').get('type')}"

user = new User({ name: 'Olaf', profile: { type: 'Snowman' } })
user.attributes
#=> { name: 'Olaf', profile: Profile({ type: 'Snowman' }) }
user.errors
#=> {}
user.title()
#=> 'Olaf the Snowman'

user = new User({ name: '', profile: { type: 'Snowman' } })
user.attributes
#=> { name: '', profile: Profile({ type: 'Snowman' }) }
user.errors
#=> { name: 'Required' }
```

### Entity.prototype.constructor

##### `new Frozen.Entity(attributes, options = { validate: true })`

Returns a new entity with the given key-value attributes.

```coffee
entity = new Frozen.Entity({ name: 'Elsa', role: 'queen' })
entity.attributes
#=> { name: 'Elsa', role: 'queen' }
```

#### Entity Validations

Because an entity's attributes are immutable, validations are performed on construction.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

user = new User({ name: 'Elsa' })
user.attributes
#=> { name: 'Elsa' }
user.errors
#=> {}

user = new User({ name: '' })
user.attributes
#=> { name: '' }
user.errors
#=> { name: 'Required' }
```

Optionally, validations can be disabled on construction.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

user = new User({ name: '' })
user.attributes
#=> { name: '' }
user.errors
#=> { name: 'Required' }

user = new User({ name: '' }, { validate: false })
user.attributes
#=> { name: '' }
user.errors
#=> {}
```

Or, validations can be forced on both `null` and `undefined` attributes on construction.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

user = new User({})
user.attributes
#=> {}
user.errors
#=> {}

user = new User({}, { validate: 'force' })
user.attributes
#=> {}
user.errors
#=> { name: 'Required' }
```

#### Entity Associations

To create structured attributes, associate them with a **Frozen.Entity** or **Frozen.Collection**.

```coffee
class Profile extends Frozen.Entity

class User extends Frozen.Entity
  associations:
    profile: Profile

user = new User({ profile: { type: 'Snowman' } })
user.attributes
#=> { profile: Profile({ type: 'Snowman' }) }
```

```coffee
class Spell extends Frozen.Entity
class Spells extends Frozen.Collection
  entity: Spell

class User extends Frozen.Entity
  associations:
    spells: Spells

user = new User({ spells: [{ type: 'Ice' }, { type: 'Snow' }] })
user.attributes
#=> { spells: Spells([{ type: 'Ice' }, { type: 'Snow' }]) }
```

To validate associated attributes, include the `association: true` property.

```coffee
class Profile extends Frozen.Entity
  validations:
    type:
      required: true

class User extends Frozen.Entity
  associations:
    profile: User

  validations:
    profile:
      association: true

user = new User({ profile: { type: '' } })
user.attributes
#=> { profile: Profile({ type: '' }) }
user.errors
#=> { profile: { type: 'Required' } }
```

### Entity.prototype.get

##### `entity.get(key)`

Given a key, returns the value of an entity's attribute.

```coffee
entity = new Frozen.Entity({ name: 'Elsa' })
entity.get('name')
#=> 'Anna'

entity.get('age')
#=> undefined
```

### Entity.prototype.set

##### `entity.set(attributes, options = @options)`

Returns a new entity by merging the given attributes into the entity's attributes. Because an entity's attributes are immutable, the original entity is unchanged.

```coffee
entity = new Frozen.Entity({ name: 'Elsa' })
entity.set({ role: 'queen' })
#=> new Frozen.Entity({ name: 'Elsa', role: 'queen' })

entity.set({ name: 'Anna' })
#=> new Frozen.Entity({ name: 'Anna' })

entity.get('name')
#=> 'Elsa'
```

Unless specified, the new entity inherits the same options as the original entity.

```coffee
mountaineer = new Frozen.Entity({ name: 'Kristoff' })
mountaineer.options
#=> { validate: true }

princess = mountaineer.set({ name: 'Anna' })
princess.options
#=> { validate: true }

queen = princess.set({ name: 'Elsa' }, { validate: false })
queen.options
#=> { validate: false }
```

### Entity.prototype.validate

##### `entity.validate(option = 'force')`

Returns a new entity with forced validations of both `null` and `undefined` attributes. Because an entity's errors are immutable, the original entity is unchanged.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

user = new User()
user.errors
#=> {}

forced = user.validate()
forced.errors
#=> { name: 'Required' }

user.errors
#=> {}
```

Optionally, returns a new entity with validations enabled or disabled. Because an entity's errors are immutable, the original entity is unchanged.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

disabled = new User({ name: '' }, { validate: false })
disabled.errors
#=> {}

enabled = user.validate(true)
enabled.errors
#=> { name: 'Required' }

disabled.errors
#=> {}
```

### Entity.prototype.isValid

##### `entity.isValid()`

Returns `true` or `false` depending on whether the entity has any errors.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

user = new User()
user.errors
#=> {}
user.isValid()
#=> true

user = user.validate()
user.errors
#=> { name: 'Required' }
user.isValid()
#=> false
```

### Entity.prototype.toJSON

##### `entity.toJSON()`

Returns a shallow copy of the entity's attributes for JSON stringification.

The name of this method is a bit confusing, as it doesn't actually return a JSON string. Unfortunately, that's the way the JavaScript API for [JSON.stringify](https://developer.mozilla.org/en-US/docs/JSON#toJSON()_method) works.

```coffee
entity = new Frozen.Entity({ name: 'Anna', princess: true })
entity.toJSON()
#=> { name: 'Anna', princess: true }
```

Includes a shallow copy of the entity's associated attributes as well.

```coffee
class Profile extends Frozen.Entity

class User extends Frozen.Entity
  associations:
    profile: Profile

user = new User({ name: 'Olaf', profile: { type: 'Snowman' } })
user.toJSON()
#=> { name: 'Olaf', profile: { type: 'Snowman' } }
```

## Frozen.Collection

Instances of **Frozen.Collection** represent a related group of entities within an application's state. They are composed of two immutable properties -- a sequence of **entities** and a **length**. They also have APIs for:

- Constructing new collections from an existing one
- Retrieving a single entity from within a collection
- Iterating through a collection's entities
- Converting a collection to JSON

A subclass extends **Frozen.Collection** with an entity property, custom iterator functions, computed properties, etc.

```coffee
class User extends Frozen.Entity

class Users extends Frozen.Collection
  entity: User

  findByName: (name) ->
    return entity for entity in @entities when entity.get('name') is name

  title: ->
    ("Princes #{entity.get('name')}" for entity in @entities)

anna = new User({ name: 'Anna' })
elsa = new User({ name: 'Elsa' })

users = new Users([ anna, elsa ])
users.entities
#=> [ User({ name: 'Anna' }), User({ name: 'Elsa' }) ]

users.length
#=> 2

users.findByName('Elsa')
#=> User({ name: 'Elsa' })

users.title()
#=> [ 'Princess Anna', 'Princess Elsa' ]
```

### Collection.prototype.constructor

##### `new Frozen.Collection(entities = [])`

Returns a new collection with the given array of entities.

```coffee
anna = new Frozen.Entity({ name: 'Anna' })
elsa = new Frozen.Entity({ name: 'Elsa' })

collection = new Frozen.Collection([ anna, elsa ])
collection.entities
#=> [ Frozen.Entity({ name: 'Anna' }), Frozen.Entity({ name: 'Elsa' }) ]

collection.length
#=> 2
```

If an array of attributes is given, new entities are instantiated.

```coffee
anna = { name: 'Anna' }
elsa = { name: 'Elsa' }

collection = new Frozen.Collection([ anna, elsa ])
collection.entities
#=> [ Frozen.Entity({ name: 'Anna' }), Frozen.Entity({ name: 'Elsa' }) ]

collection.length
#=> 2
```

To instantiate custom entities, provide a `entity` property.

```coffee
class User extends Frozen.Entity

class Users extends Frozen.Collection
  entity: User

anna = { name: 'Anna' }
elsa = { name: 'Elsa' }

users = new Users([ anna, elsa ])
users.entities
#=> [ User({ name: 'Anna' }), User({ name: 'Elsa' }) ]

users.length
#=> 2
```

The constructor accepts a single entity or attributes object as well as no arguments at all.

```coffee
anna = new Frozen.Entity({ name: 'Anna' })

collection = new Frozen.Collection(anna)
collection.entities
#=> [ Frozen.Entity({ name: 'Anna' }) ]

collection.length
#=> 1
```

```coffee
collection = new Frozen.Collection()
collection.entities
#=> []

collection.length
#=> 0
```

### Collection.prototype.at

##### `collection.at(index)`

Returns the entity at the given index positioned by insertion order.

```coffee
collection = new Frozen.Collection({ name: 'Anna' })
collection.at(0)
#=> Frozen.Entity({ name: 'Anna' })

collection.at(1)
#=> undefined
```

### Collection.prototype.insert

##### `collection.insert(index, entity = {})`

Returns a new collection with the given entity inserted at the given index positioned by insertion order. Because a collection's entities are immutable, the original collection is unchanged.

```coffee
collection = new Frozen.Collection({ name: 'Elsa' })

entity = new Frozen.Entity({ name: 'Anna' })
collection.insert(0, entity)
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Anna' }),
#     Frozen.Entity({ name: 'Elsa' })
#   ])

collection.insert(1, entity)
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Elsa' }),
#     Frozen.Entity({ name: 'Anna' })
#   ])

collection.entities
#=> [ Frozen.Entity({ name: 'Elsa' }) ]
```

If attributes are given, a new entity is instantiated.

```coffee
collection = new Frozen.Collection({ name: 'Elsa' })

entity = { name: 'Anna' }
collection.insert(0, entity)
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Anna' }),
#     Frozen.Entity({ name: 'Elsa' })
#   ])

collection.insert(1, entity)
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Elsa' }),
#     Frozen.Entity({ name: 'Anna' })
#   ])

collection.entities
#=> [ Frozen.Entity({ name: 'Elsa' }) ]
```

To instantiate a custom entity, provide a `entity` property.

```coffee
class User extends Frozen.Entity

class Users extends Frozen.Collection
  entity: User

users = new Users({ name: 'Elsa' })

user = { name: 'Anna' }
users.insert(0, user)
#=> new Users([
#     User({ name: 'Anna' }),
#     User({ name: 'Elsa' })
#   ])

users.insert(1, user)
#=> new Users([
#     User({ name: 'Elsa' }),
#     User({ name: 'Anna' })
#   ])

users.entities
#=> [ User({ name: 'Elsa' }) ]
```

### Collection.prototype.push

##### `collection.push(entity = {})`

Returns a new collection with the given entity appended to the end. Because a collection's entities are immutable, the original collection is unchanged.

```coffee
collection = new Frozen.Collection({ name: 'Elsa' })

entity = new Frozen.Entity({ name: 'Anna' })
collection.push(entity)
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Elsa' }),
#     Frozen.Entity({ name: 'Anna' })
#   ])

collection.entities
#=> [ Frozen.Entity({ name: 'Elsa' }) ]
```

If attributes are given, a new entity is instantiated.

```coffee
collection = new Frozen.Collection({ name: 'Elsa' })

entity = { name: 'Anna' }
collection.push(entity)
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Elsa' }),
#     Frozen.Entity({ name: 'Anna' })
#   ])

collection.entities
#=> [ Frozen.Entity({ name: 'Elsa' }) ]
```

To instantiate a custom entity, provide a `entity` property.

```coffee
class User extends Frozen.Entity

class Users extends Frozen.Collection
  entity: User

users = new Users({ name: 'Elsa' })

user = { name: 'Anna' }
users.push(user)
#=> new Users([
#     User({ name: 'Elsa' }),
#     User({ name: 'Anna' })
#   ])

users.entities
#=> [ User({ name: 'Elsa' }) ]
```

### Collection.prototype.change

##### `collection.change(index, attributes)`

Returns a new collection by merging the given attributes into the collection's entity at the given index. Because a collection's entities are immutable, the original collection is unchanged.

```coffee
collection = new Frozen.Collection({ name: 'Elsa' })

collection.change(0, { role: 'Snow Queen' })
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Elsa', role: 'Snow Queen' })
#   ])

collection.change(0, { name: 'Anna' })
#=> new Frozen.Collection([
#     Frozen.Entity({ name: 'Anna' })
#   ])

collection.entities
#=> [ Frozen.Entity({ name: 'Elsa' }) ]
```

### Collection.prototype.remove

##### `collection.remove(index)`

Returns a new collection without the entity at the given index. Because a collection's entities are immutable, the original collection is unchanged.

```coffee
collection = new Frozen.Collection({ name: 'Elsa' })

collection.remove(0)
#=> new Frozen.Collection([])

collection.entities
#=> [ Frozen.Entity({ name: 'Elsa' }) ]
```

### Collection.prototype.validate

##### `collection.validate()`

Returns a new collection with forced validations for all entities. Because a collection's entities are immutable, the original collection is unchanged.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

class Users extends Frozen.Collection
  entity: User

users = new Users({ name: null })
user.at(0).errors
#=> {}

forced = user.validate()
forced.at(0).errors
#=> { name: 'Required' }

user.at(0).errors
#=> {}
```

### Collection.prototype.isValid

##### `collection.isValid()`

Returns `true` or `false` depending on whether all entities are valid.

```coffee
class User extends Frozen.Entity
  validations:
    name:
      required: true

class Users extends Frozen.Collection
  entity: User

users = new Users({ name: null })
user.at(0).errors
#=> {}
user.isValid()
#=> true

users = users.validate()
users.at(0).errors
#=> { name: 'Required' }
user.isValid()
#=> false
```

### Collection.prototype.map

##### `collection.map(callback, thisArg)`

Returns a new Array of values by mapping each entity in the collection through a transformation callback function. The callback accepts the following arguments:

* `entity` - The current entity being processed. (Optional)
* `index` - The index of the current entity positioned by insertion order. (Optional)
* `entities` - The array of entities in the collection. (Optional)


Optionally, the callback may be given a thisArg to use as `this` when executing.


### Collection.prototype.toJSON

##### `collection.toJSON()`

Returns an array of the collection's entities for JSON stringification by leveraging `entity.toJSON()`.

The name of this method is a bit confusing, as it doesn't actually return a JSON string. Unfortunately, that's the way the JavaScript API for [JSON.stringify](https://developer.mozilla.org/en-US/docs/JSON#toJSON()_method) works.


## Thank you

Without these technologies, **Frozen** would not exist.

- [React](http://facebook.github.io/react/)
- [Backbone.js](http://backbonejs.org/)
- [Gary Bernhardt](https://twitter.com/garybernhardt)
