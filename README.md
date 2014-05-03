## Frozen v0.1.0 (Not yet released)

**Frozen** provides immutable models and collections for Node and browser apps.

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

royals.add({name: 'Anna'})
#=> new Frozen.Collection([{ name: 'Elsa' }, { name: 'Anna' }])

royals.change(0, { name: 'Snow Queen' })
#=> new Frozen.Collection({ name: 'Snow Queen' })

royals.remove(0)
#=> new Frozen.Collection()

royals.at(0)
#=> Frozen.Model({ name: 'Elsa' })
```

## Frozen.Model

A **Frozen.Model** represent an application's state with key-value **attributes** and possible validation **errors**.

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

### constructor

##### `new Frozen.Model(attributes, options)`

To create an instance of a model, simply pass in key-value attributes.

```coffee
model = new Frozen.Model({ name: 'Elsa', role: 'queen' })
model.attributes
#=> { name: 'Elsa', role: 'queen' }
```

#### Validations

Because instances of **Frozen.Model** are immutable, validations are performed on construction.

```coffee
class User extends Frozen.Model
  validations:
    name:
      required: true

user = new User({ name: 'Elsa', role: 'queen' })
user.attributes
#=> { name: 'Elsa', role: 'queen' }
user.errors
#=> {}

user = new User({ name: '', role: 'queen' })
user.attributes
#=> { name: '', role: 'queen' }
user.errors
#=> { name: 'Required' }
```

To force validation on both `null` and `undefined` attributes, supply the `validation: 'force'` option.

```coffee
class User extends Frozen.Model
  validations:
    name:
      required: true

user = new User({ role: 'queen' })
user.attributes
#=> { role: 'queen' }
user.errors
#=> {}

user = new User({ role: 'queen' }, { validation: 'force' })
user.attributes
#=> { role: 'queen' }
user.errors
#=> { name: 'Required' }
```

#### Associations

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

### get

##### `model.get(key)`

Given a key, fetch the value of a model's attribute.

```coffee
model = new Frozen.Model({ name: 'Elsa' })
model.get('name')
#=> 'Anna'
model.get('age')
#=> undefined
```

### set

##### `model.set(attributes, options)`

Create a new instance by merging new key-value attributes into the model's attributes. Because instances of **Frozen.Model** are immutable, the original model is unchanged.

```coffee
model = new Frozen.Model({ name: 'Anna' })
model.set({ role: 'queen' })
#=> new Frozen.Model({ name: 'Anna', role: 'queen' })
model.set({ name: 'Elsa' })
#=> new Frozen.Model({ name: 'Elsa' })
model.get('name')
#=> 'Anna'
```

The new instance has the same constructor options as the original model unless specified.

```coffee
mountaineer = new Frozen.Model({ name: 'Kristoff' })
mountaineer.options
#=> {}

princess = mountaineer.set({ name: 'Anna' })
princess.options
#=> {}

queen = princess.set({ name: 'Elsa' }, { validation: 'force' })
queen.options
#=> { validation: 'force' }
```

### validate

##### `model.validate()`

Create a new instance with forced validations of `null` and `undefined` attributes.

```coffee
class User extends Frozen.Model
  validations:
    name:
      required: true

user = new User()
user.errors
#=> {}

user = user.validate()
user.errors
#=> { name: 'Required' }
```

### isValid

##### `model.isValid()`

Returns `true` or `false` whether or not the model has any errors.

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

### toJSON

##### `model.toJSON()`

Returns a shallow copy of a model's key-value attributes for JSON stringification.

The name of this method is a bit confusing, as it doesn't actually return a JSON string. Unfortunately, that's the way the JavaScript API for [JSON.stringify](https://developer.mozilla.org/en-US/docs/JSON#toJSON()_method) works.

```coffee
model = new Frozen.Model({ name: 'Anna', princess: true })
model.toJSON()
#=> { name: 'Anna', princess: true }
```

Includes a shallow copy of a model's associated key-value attributes as well.

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

**Collections** have a rich API of enumerable functions

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


## Why

Speed up your React application _and_ your development time by using immutable data structures with familiar APIs.


## Guides

- The wiki
- This article


## Thank you

Without these technologies, **Frozen** would not exist.

- [React](http://facebook.github.io/react/)
- [Backbone.js](http://backbonejs.org/)

---

The MIT license - Copyright (c) 2014 [Kurbo Health](http://kurbo.com/) - Author [Ryan Sobol](http://ryansobol.com)
