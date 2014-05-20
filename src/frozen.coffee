# See https://github.com/thedersen/backbone.validation for an example API
class Validation
  @required: (key, value, opts, entity) ->
    opts.message ? 'Required' if not value? or value.trim() is ''

  @association: (key, value, opts, entity) ->
    value.errors if value? and not value.isValid()

extend = (to, froms...) ->
  for from in froms
    to[prop] = value for prop, value of from when from.hasOwnProperty(prop)
  to

class Entity
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

          error = validator(key, value, opts, this)
          continue unless error?

          errors[key] = error
          break

    Object.defineProperty(this, 'attributes', value: Object.freeze(attributes))
    Object.defineProperty(this, 'errors', value: Object.freeze(errors))
    Object.defineProperty(this, 'options', value: options)

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
  entity: Entity

  constructor: (entities = []) ->
    entities = [entities] unless entities instanceof Array

    entities = for entity in entities
      if entity instanceof Entity then entity else new @entity(entity)

    Object.defineProperty(this, 'entities', value: Object.freeze(entities))
    Object.defineProperty(this, 'length', value: entities.length)

  at: (index) ->
    @entities[index]

  insert: (index, entity = {}) ->
    entities = @entities[...index]
    entities.push(entity)
    entities = entities.concat(@entities[index..])
    new @constructor(entities)

  push: (entity = {}) ->
    @insert(@length, entity)

  change: (index, attributes) ->
    entities = for entity, idx in @entities
      if index is idx then entity.set(attributes) else entity
    new @constructor(entities)

  remove: (index) ->
    entities = (entity for entity, idx in @entities when index isnt idx)
    new @constructor(entities)

  validate: ->
    entities = (entity.validate() for entity in @entities)
    new @constructor(entities)

  isValid: ->
    @entities.reduce ((a, e) -> a and e.isValid()), true

  map: (callback, thisArg) ->
    @entities.map(callback, thisArg)

  toJSON: ->
    entity.toJSON() for entity in @entities

Frozen =
  Entity: Entity
  Collection: Collection
  Validation: Validation

if module?
  module.exports = Frozen
else
  window.Frozen = Frozen
