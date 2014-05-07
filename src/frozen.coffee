# See https://github.com/thedersen/backbone.validation for an example API
class Validation
  @required: (key, value, opts, model) ->
    opts.message ? 'Required' if not value? or value.trim() is ''

  @association: (key, value, opts, model) ->
    value.errors if value? and not value.isValid()

extend = (to, froms...) ->
  for from in froms
    to[prop] = value for prop, value of from when from.hasOwnProperty(prop)
  to

class Model
  constructor: (attributes, options = { validate: true }) ->
    attributes = extend({}, attributes)
    errors = {}

    for key, association of @associations
      value = attributes[key]
      continue unless value?

      if value instanceof association
        continue if options.validate is value.options.validate
        value = value.attributes

      attributes[key] = new association(value, options)

    if options.validate
      for key, validation of @validations
        value = attributes[key]
        continue unless options.validate is 'force' or value?

        for type, opts of validation
          continue unless opts

          validator = Validation[type]
          continue unless validator?

          error = validator(key, value, opts, @)
          continue unless error?

          errors[key] = error
          break

    Object.defineProperty(@, 'attributes', value: Object.freeze(attributes))
    Object.defineProperty(@, 'errors', value: Object.freeze(errors))
    Object.defineProperty(@, 'options', value: options)

  get: (key) ->
    @attributes[key]

  set: (attributes, options = @options) ->
    attributes = extend({}, @attributes, attributes)
    new @constructor(attributes, options)

  validate: (option = 'force') ->
    options = extend({}, @options, { validate: option })
    new @constructor(@attributes, options)

  isValid: ->
    Object.keys(@errors).length is 0

  toJSON: ->
    attributes = extend({}, @attributes)
    for key of @associations
      continue unless attributes[key]?
      attributes[key] = attributes[key].toJSON()
    attributes

class Collection
  model: Model

  constructor: (models = []) ->
    models = [models] unless models instanceof Array

    models = for model in models
      if model instanceof Model then model else new @model(model)

    Object.defineProperty(@, 'models', value: Object.freeze(models))
    Object.defineProperty(@, 'length', value: models.length)

  at: (index) ->
    @models[index]

  insert: (index, model = {}) ->
    model = new @model(model) unless model instanceof Model
    models = @models[...index]
    models.push(model)
    models = models.concat(@models[index..])
    new @constructor(models)

  push: (model = {}) ->
    @insert(@length, model)

  change: (index, attributes) ->
    models = for model, idx in @models
      if index is idx then model.set(attributes) else model
    new @constructor(models)

  remove: (index) ->
    models = (model for model, idx in @models when index isnt idx)
    new @constructor(models)

  validate: ->
    models = (model.validate() for model in @models)
    new @constructor(models)

  isValid: ->
    @models.reduce ((a, e) -> a and e.isValid()), true

  map: (callback, thisArg) ->
    @models.map(callback, thisArg)

  toJSON: ->
    model.toJSON() for model in @models

Frozen =
  Model: Model
  Collection: Collection
  Validation: Validation

if module?
  module.exports = Frozen
else
  window.Frozen = Frozen
