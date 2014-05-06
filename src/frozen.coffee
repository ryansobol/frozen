# See https://github.com/thedersen/backbone.validation for an example API
class Validation
  @required: (prop, value, opts, model) ->
    opts.message ? 'Required' if not value? or value.trim() is ''

  @association: (prop, value, opts, model) ->
    value.errors if value? and not value.isValid()

extend = (to, froms...) ->
  for from in froms
    to[prop] = value for prop, value of from when from.hasOwnProperty(prop)
  to

class Model
  constructor: (@attributes, @force = false) ->
    @attributes = extend({}, @attributes)
    @errors = {}

    for prop, association of @associations
      value = @attributes[prop]
      continue unless value?

      if value instanceof association
        continue if @force is value.force
        value = value.attributes

      @attributes[prop] = new association(value, @force)

    for prop, validation of @validations
      value = @attributes[prop]
      continue unless @force or value?

      for type, opts of validation
        continue unless opts

        validator = Validation[type]
        continue unless validator?

        error = validator(prop, value, opts, @)
        continue unless error?

        @errors[prop] = error
        break

    Object.freeze(@attributes)
    Object.freeze(@errors)

  get: (prop) ->
    @attributes[prop]

  set: (attributes, force = @force) ->
    attributes = extend({}, @attributes, attributes)
    new @constructor(attributes, force)

  validate: ->
    new @constructor(@attributes, true)

  isValid: ->
    Object.keys(@errors).length is 0

  toJSON: ->
    attributes = extend({}, @attributes)
    for prop of @associations
      continue unless attributes[prop]?
      attributes[prop] = attributes[prop].toJSON()
    attributes

class Collection
  model: Model

  constructor: (models = []) ->
    models = [models] unless models instanceof Array

    @models = for model in models
      if model instanceof Model then model else new @model(model)

    @length = @models.length

    Object.freeze @models

  at: (key) ->
    @models[key]

  add: (model = {}) ->
    model = new @model(model) unless model instanceof Model
    models = @models.concat([model])
    new @constructor(models)

  change: (key, attributes) ->
    models = for model, index in @models
      if index is key then model.set(attributes) else model
    new @constructor(models)

  remove: (key) ->
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
