## Frozen v0.1.0 (Not yet released)

Immutable model and collection classes for [React](http://facebook.github.io/react/) based on [Backbone.js](http://backbonejs.org/)

```coffee
class User extends Frozen.Model

class Users extends Frozen.Collection
  model: User

users = new Users [{ name: 'Anna' }, { name: 'Elsa' }]

queen = users.at(1)
names = users.map (u) -> u.get('name')
```

Speed up your React application _and_ your development time by using immutable data structures with familiar APIs.


### Features

- Models have key-value attributes and validation
- Collections have a rich API of enumerable functions


### Guides

- The wiki
- This article


---

The MIT license - Copyright (c) 2014 [Kurbo Health](http://kurbo.com/) - Author [Ryan Sobol](http://ryansobol.com)
