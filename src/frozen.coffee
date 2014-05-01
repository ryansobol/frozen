# See https://github.com/thedersen/backbone.validation for an example API
class Validation
  @required: (prop, value, opts, model) ->
    opts.message ? 'Required' if not value? or value.trim() is ''

  @coersion: (prop, value, opts, model) ->
    value.errors if value? and not value.isValid()

extend = (to, froms...) ->
  for from in froms
    to[prop] = value for prop, value of from when from.hasOwnProperty(prop)
  to

class Model
  constructor: (@attributes, @options) ->
    @attributes = extend({}, @attributes)
    @options = extend({}, @options)
    @errors = {}

    for prop, coersion of @coersions
      value = @attributes[prop]
      continue unless value?

      value = value.attributes if value instanceof coersion
      @attributes[prop] = new coersion(value, @options)

    for prop, validation of @validations
      value = @attributes[prop]
      continue unless @options.validation is 'force' or value?

      for type, opts of validation
        # continue unless opts

        validator = Validation[type]
        continue unless validator?

        error = validator(prop, value, opts, @)
        continue unless error?

        @errors[prop] = error
        break

    Object.freeze(@attributes)
    Object.freeze(@options)
    Object.freeze(@errors)

  get: (prop) ->
    @attributes[prop]

  set: (attributes, options = @options) ->
    attributes = extend({}, @attributes, attributes)
    new @constructor(attributes, options)

  validate: ->
    new @constructor(@attributes, validation: 'force')

  isValid: ->
    Object.keys(@errors).length is 0

  toJSON: ->
    attributes = extend({}, @attributes)
    for prop of @coersions
      continue unless attributes[prop]?
      attributes[prop] = attributes[prop].toJSON()
    attributes

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

  change: (key, attributes) ->
    models = for model, index in @models
      if index is key then model.set(attributes) else model

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

Frozen =
  Model: Model
  Collection: Collection
  Validation: Validation

if module?
  module.exports = Frozen
else
  window.Frozen = Frozen
