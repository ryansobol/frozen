## Frozen v0.1.0 (Not yet released)

**Frozen** provides immutable models and collections for Node and browser apps.

- The README
- The wiki
- The article(s)
- The issue tracker
- The stackoverflow page
- The twitter account

The MIT license - Copyright (c) 2014 [Kurbo Health](http://kurbo.com/) - Author [Ryan Sobol](http://ryansobol.com)


## Example

```coffee
princess = new Frozen.Model({ name: 'Anna' })
princess.get('name')  
#=> 'Anna'

princess.set({ trait: 'adorkable' })
#=> new Frozen.Model({ name: 'Anna', trait: 'adorkable' })

princess.set({ name: 'Elsa' })
#=> new Frozen.Model({ name: 'Elsa' })

princess.get('name')
#=> 'Anna'
```

```coffee
royals = new Frozen.Collection({ name: 'Elsa' })
royals.at(0)
#=> Frozen.Model({ name: 'Elsa' })

royals.push({name: 'Anna'})
#=> new Frozen.Collection([{ name: 'Elsa' }, { name: 'Anna' }])

royals.change(0, { name: 'Snow Queen' })
#=> new Frozen.Collection({ name: 'Snow Queen' })

royals.remove(0)
#=> new Frozen.Collection()

royals.at(0)
#=> Frozen.Model({ name: 'Elsa' })
```

## Introduction

I wrote Frozen for two reasons -- faster React performance and faster development time.

[INSERT RATIONALE FOR IMMUTABLE DATA STRUCTURES WITH REACT]

[INSERT RATIONALE ON BACKBONE'S DATA MODELING]

While it's probably not bug free, Frozen has a comprehensive test suite. I'm using Frozen in a production environment without any issues.

Please be aware that Frozen is pre-1.0 software. This means function signatures or behavior may change. If a breaking change is necessary, I'll be sure to give a deprecation warning that includes a fix and when the feature will be removed.


## Contributing

There are a bunch of Backbone features that I'd like to see ported over. If you create a fork, please consider submitting a pull request.

In your pull request, please make a strong case as to why the changes are necessary.  Providing example code and tests significantly increases the chances your pull request is accepted.


## Frozen.Model

Instances of **Frozen.Model** represent a single entity in an application's state. They consist of immutable key-value **attributes** and validation **errors**. They also have APIs for retrieving a single attribute, constructing new models, and converting attributes to JSON.

Custom models extend **Frozen.Model** with domain-specific validation rules, associated attributes, computed properties, etc.

```coffee
class Profile extends Frozen.Model

class User extends Frozen.Model
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

### Model.prototype.constructor

##### `new Frozen.Model(attributes, options = { validate: true })`

Returns a new model with the given key-value attributes.

```coffee
model = new Frozen.Model({ name: 'Elsa', role: 'queen' })
model.attributes
#=> { name: 'Elsa', role: 'queen' }
```

#### Model Validations

Because model attributes are immutable, validations are performed on construction.

```coffee
class User extends Frozen.Model
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
class User extends Frozen.Model
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
class User extends Frozen.Model
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

#### Model Associations

To create structured attributes, associate them with a **Frozen.Model** or **Frozen.Collection**.

```coffee
class Profile extends Frozen.Model

class User extends Frozen.Model
  associations:
    profile: Profile

user = new User({ profile: { type: 'Snowman' } })
user.attributes
#=> { profile: Profile({ type: 'Snowman' }) }
```

```coffee
class Spell extends Frozen.Model
class Spells extends Frozen.Collection
  model: Spell

class User extends Frozen.Model
  associations:
    spells: Spells

user = new User({ spells: [{ type: 'Ice' }, { type: 'Snow' }] })
user.attributes
#=> { spells: Spells([{ type: 'Ice' }, { type: 'Snow' }]) }
```

To validate associated attributes, include the `association: true` property.

```coffee
class Profile extends Frozen.Model
  validations:
    type:
      required: true

class User extends Frozen.Model
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

### Model.prototype.get

##### `model.get(key)`

Given a key, returns the value of a model's attribute.

```coffee
model = new Frozen.Model({ name: 'Elsa' })
model.get('name')
#=> 'Anna'
model.get('age')
#=> undefined
```

### Model.prototype.set

##### `model.set(attributes, options = @options)`

Returns a new model by merging the given attributes into the model's attributes. Because model attributes are immutable, the original model is unchanged.

```coffee
model = new Frozen.Model({ name: 'Anna' })
model.set({ role: 'queen' })
#=> new Frozen.Model({ name: 'Anna', role: 'queen' })
model.set({ name: 'Elsa' })
#=> new Frozen.Model({ name: 'Elsa' })
model.get('name')
#=> 'Anna'
```

Unless specified, the new model inherits the same options as the original model.

```coffee
mountaineer = new Frozen.Model({ name: 'Kristoff' })
mountaineer.options
#=> { validate: true }

princess = mountaineer.set({ name: 'Anna' })
princess.options
#=> { validate: true }

queen = princess.set({ name: 'Elsa' }, { validate: false })
queen.options
#=> { validate: false }
```

### Model.prototype.validate

##### `model.validate(option = 'force')`

Returns a new model with forced validations of both `null` and `undefined` attributes. Because model errors are immutable, the original model is unchanged.

```coffee
class User extends Frozen.Model
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

Optionally, returns a new model with validations enabled or disabled. Because model errors are immutable, the original model is unchanged.

```coffee
class User extends Frozen.Model
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

### Model.prototype.isValid

##### `model.isValid()`

Returns `true` or `false` depending on whether the model has any errors.

```coffee
class User extends Frozen.Model
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

### Model.prototype.toJSON

##### `model.toJSON()`

Returns a shallow copy of the model's attributes for JSON stringification.

The name of this method is a bit confusing, as it doesn't actually return a JSON string. Unfortunately, that's the way the JavaScript API for [JSON.stringify](https://developer.mozilla.org/en-US/docs/JSON#toJSON()_method) works.

```coffee
model = new Frozen.Model({ name: 'Anna', princess: true })
model.toJSON()
#=> { name: 'Anna', princess: true }
```

Includes a shallow copy of the model's associated attributes as well.

```coffee
class Profile extends Frozen.Model

class User extends Frozen.Model
  associations:
    profile: Profile

user = new User({ name: 'Olaf', profile: { type: 'Snowman' } })
user.toJSON()
#=> { name: 'Olaf', profile: { type: 'Snowman' } }
```

## Frozen.Collection

Instances of **Frozen.Collection** represent a related group of entities in an application's state. They consist of an ordered and immutable series of **models**. They also have APIs for retrieving a single model, constructing new models, and converting models to JSON.

Custom collections extend **Frozen.Collection** with a custom model definition, domain-specific validation rules, associated model, computed properties, etc.

```coffee
class Subject extends Frozen.Model

class Subjects extends Frozen.Collection
  model: Subject

baker = new Subject({role: 'baker'})
merchant = new Subject({role: 'merchant'})

subjects = new Subjects(baker, merchant)
#=> new Subjects([ new Subject({role: 'baker'}), new Subject({role: 'merchant'}) ])

subjects.map()
#=> false

creature = new Spell({name: 'Snowman', spell: { power: 9000 }})
#=> new Creature({name: 'Snowman', spell: new Spell({power: 9000})})

creature.isValid()
#=> true
```

### Collection.prototype.constructor

##### `new Frozen.Collection(models = [])`

Returns a new collection with the given array of models.


If an array of attributes is given, new models are instantiated.


To instantiate custom models, provide a `model` property.


### Collection.prototype.at

##### `collection.at(index)`

Returns the model at the given index positioned by insertion order.


### Collection.prototype.insert

##### `collection.insert(index, model = {})`

Returns a new collection with the given model inserted at the given index positioned by insertion order. Because collection models are immutable, the original collection is unchanged.


### Collection.prototype.push

##### `collection.push(model = {})`

Returns a new collection with the given model appended to the end. Because collection models are immutable, the original collection is unchanged.


If attributes are given, a new model is instantiated.


To instantiate a custom model, provide a `model` property.


### Collection.prototype.change

##### `collection.change(index, attributes)`

Returns a new collection by merging the given attributes into the collection's model at the given index. Because collection models are immutable, the original collection is unchanged.


### Collection.prototype.remove

##### `collection.remove(index)`

Returns a new collection without the model at the given index. Because collection models are immutable, the original collection is unchanged.


### Collection.prototype.validate

##### `collection.validate()`

Returns a new collection with forced validations for all models. Because collection models are immutable, the original collection is unchanged.


### Collection.prototype.isValid

##### `collection.isValid()`

Returns `true` or `false` depending on whether all models are valid.


### Collection.prototype.map

##### `collection.map(callback, thisArg)`

Returns a new Array of values by mapping each model in the collection through a transformation callback function. The callback accepts the following arguments:

* `model` - The current model being processed. (Optional)
* `index` - The index of the current model positioned by insertion order. (Optional)
* `models` - The array of models in the collection. (Optional)


Optionally, the callback may be given a thisArg to use as `this` when executing.


### Collection.prototype.toJSON

##### `collection.toJSON()`

Returns an array of the collection's models for JSON stringification by leveraging `model.toJSON()`.

The name of this method is a bit confusing, as it doesn't actually return a JSON string. Unfortunately, that's the way the JavaScript API for [JSON.stringify](https://developer.mozilla.org/en-US/docs/JSON#toJSON()_method) works.


## Thank you

Without these technologies, **Frozen** would not exist.

- [React](http://facebook.github.io/react/)
- [Backbone.js](http://backbonejs.org/)
