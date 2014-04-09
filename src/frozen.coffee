extend = (to, froms...) ->
  for from in froms
    to[prop] = value for prop, value of from when from.hasOwnProperty(prop)
  to

# An immutable model based on Backbone.Model
class Model
  # Accepts an Object
  #
  # Example:
  #  { firstName: 'Kevin', lastName: 'Bacon' }
  #
  constructor: (attributes = {}) ->
    @attributes = Object.freeze(attributes)

    @errors = {}

    for prop, value of @attributes
      error = @["#{prop}Error"]?(value)
      @errors[prop] = error if error?

    Object.freeze(@errors)

  get: (prop) ->
    @attributes[prop]

  set: (prop, value) ->
    attributes = extend({}, @attributes)
    attributes[prop] = value
    new @constructor(attributes)

  toJSON: ->
    @attributes

  validProps: []

  validate: ->
    attributes = extend({}, @attributes)
    attributes[prop] ?= '' for prop in @validProps
    new @constructor(attributes)

  isValid: ->
    Object.keys(@errors).length is 0

# An immutable collection based on Backbone.Collection
class Collection
  model: Model

  # Accepts an Object
  #
  # Example:
  #  { firstName: 'Kevin', lastName: 'Bacon' }
  #
  # Accepts an Array of Objects
  #
  # Example:
  #   [
  #     { firstName: 'Michelle', lastName: 'Obama' },
  #     { firstName: 'Emma', lastName: 'Stone' }
  #   ]
  #
  # Accepts a Model
  #
  # Example:
  #  new Model({ firstName: 'Kevin', lastName: 'Bacon' })
  #
  # Accepts an Array of Models
  #
  # Example:
  #   [
  #     new Model({ firstName: 'Michelle', lastName: 'Obama' }),
  #     new Model({ firstName: 'Emma', lastName: 'Stone' })
  #   ]
  #
  constructor: (models = []) ->
    models = [models] unless models instanceof Array

    @models = for model in models
      if model instanceof Model then model else new @model(model)

    @length = @models.length

    Object.freeze @models

  at: (key) ->
    @models[key]

  add: (model = {}) ->
    model  = new @model(model) unless model instanceof Model
    models = @models.concat([model])
    new @constructor(models)

  change: (key, prop, value) ->
    models = for model, index in @models
      if index is key then model.set(prop, value) else model

    new @constructor(models)

  destroy: (key) ->
    models = (model for model, index in @models when index isnt key)
    new @constructor(models)

  map: (callback, thisArg) ->
    @models.map(callback, thisArg)

  toJSON: ->
    model.toJSON() for model in @models

  validate: ->
    models = (model.validate() for model in @models)
    new @constructor(models)

  isValid: ->
    @models.reduce ((a, e) -> a and e.isValid()), true

Frozen = { Model: Model, Collection: Collection }

if module?
  module.exports = Frozen
else
  window.Frozen = Frozen
