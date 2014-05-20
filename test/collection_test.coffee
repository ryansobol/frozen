expect = require 'expect.js'
{Collection, Entity} = require '../src/frozen'

class Person extends Entity
  validations:
    name:
      required: true

class PersonCollection extends Collection
  entity: Person

describe 'Collection', ->
  describe 'constructor', ->
    describe 'given no object', ->
      beforeEach ->
        @collection = new Collection()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'has the correct entities at', ->
        expect(@collection.at(0)).to.eql undefined

    describe 'given an object', ->
      beforeEach ->
        @object = { name: 'Jim' }
        @collection = new Collection(@object)

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [new Entity(@object)]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct entities at', ->
        expect(@collection.at(0)).to.eql new Entity(@object)
        expect(@collection.at(1)).to.eql undefined

    describe 'given two objects', ->
      beforeEach ->
        @object0 = { name: 'Jim' }
        @object1 = { name: 'Ted' }
        @collection = new Collection([@object0, @object1])

      it 'has the correct entities', ->
        expected = [new Entity(@object0), new Entity(@object1)]
        expect(@collection.entities).to.eql expected

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct entities at', ->
        expect(@collection.at(0)).to.eql new Entity(@object0)
        expect(@collection.at(1)).to.eql new Entity(@object1)
        expect(@collection.at(2)).to.eql undefined

    describe 'given a entity', ->
      beforeEach ->
        @entity = new Entity(name: 'Jim')
        @collection = new Collection(@entity)

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct entities at', ->
        expect(@collection.at(0)).to.eql @entity
        expect(@collection.at(1)).to.eql undefined

    describe 'given two entities', ->
      beforeEach ->
        @entity0 = new Entity(name: 'Jim')
        @entity1 = new Entity(name: 'Ted')
        @collection = new Collection([@entity0, @entity1])

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity0, @entity1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct entities at', ->
        expect(@collection.at(0)).to.eql @entity0
        expect(@collection.at(1)).to.eql @entity1
        expect(@collection.at(2)).to.eql undefined

  describe 'insert', ->
    describe 'given an index of 0', ->
      beforeEach ->
        @index = 0

      describe 'given no object', ->
        beforeEach ->
          @initial = new Entity(name: 'Bob')
          @collection = new Collection(@initial)
          @returns = @collection.insert(@index)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct entities', ->
          expect(@returns.entities).to.eql [new Entity(), @initial]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct entities at', ->
          expect(@returns.at(0)).to.eql new Entity()
          expect(@returns.at(1)).to.eql @initial

      describe 'given an object', ->
        beforeEach ->
          @initial = new Entity(name: 'Bob')
          @collection = new Collection(@initial)
          @object = { name: 'Tom' }
          @returns = @collection.insert(@index, @object)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct entities', ->
          expect(@returns.entities).to.eql [new Entity(@object), @initial]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct entities at', ->
          expect(@returns.at(0)).to.eql new Entity(@object)
          expect(@returns.at(1)).to.eql @initial

      describe 'given a entity', ->
        beforeEach ->
          @initial = new Entity(name: 'Bob')
          @collection = new Collection(@initial)
          @entity = new Entity(name: 'Tom')
          @returns = @collection.insert(@index, @entity)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct entities', ->
          expect(@returns.entities).to.eql [@entity, @initial]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct entities at', ->
          expect(@returns.at(0)).to.eql @entity
          expect(@returns.at(1)).to.eql @initial

    describe 'given an index of 1', ->
      beforeEach ->
        @index = 1

      describe 'given no object', ->
        beforeEach ->
          @initial = new Entity(name: 'Bob')
          @collection = new Collection(@initial)
          @returns = @collection.insert(@index)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct entities', ->
          expect(@returns.entities).to.eql [@initial, new Entity()]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct entities at', ->
          expect(@returns.at(0)).to.eql @initial
          expect(@returns.at(1)).to.eql new Entity()

      describe 'given an object', ->
        beforeEach ->
          @initial = new Entity(name: 'Bob')
          @collection = new Collection(@initial)
          @object = { name: 'Tom' }
          @returns = @collection.insert(@index, @object)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct entities', ->
          expect(@returns.entities).to.eql [@initial, new Entity(@object)]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct entities at', ->
          expect(@returns.at(0)).to.eql @initial
          expect(@returns.at(1)).to.eql new Entity(@object)

      describe 'given a entity', ->
        beforeEach ->
          @initial = new Entity(name: 'Bob')
          @collection = new Collection(@initial)
          @entity = new Entity(name: 'Tom')
          @returns = @collection.insert(@index, @entity)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct entities', ->
          expect(@returns.entities).to.eql [@initial, @entity]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct entities at', ->
          expect(@returns.at(0)).to.eql @initial
          expect(@returns.at(1)).to.eql @entity

  describe 'push', ->
    describe 'given no object', ->
      beforeEach ->
        @initial = new Entity(name: 'Bob')
        @collection = new Collection(@initial)
        @returns = @collection.push()

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@initial, new Entity()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct entities at', ->
        expect(@returns.at(0)).to.eql @initial
        expect(@returns.at(1)).to.eql new Entity()

    describe 'given an object', ->
      beforeEach ->
        @initial = new Entity(name: 'Bob')
        @collection = new Collection(@initial)
        @object = { name: 'Tom' }
        @returns = @collection.push(@object)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@initial, new Entity(@object)]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct entities at', ->
        expect(@returns.at(0)).to.eql @initial
        expect(@returns.at(1)).to.eql new Entity(@object)

    describe 'given a entity', ->
      beforeEach ->
        @initial = new Entity(name: 'Bob')
        @collection = new Collection(@initial)
        @entity = new Entity(name: 'Tom')
        @returns = @collection.push(@entity)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@initial, @entity]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct entities at', ->
        expect(@returns.at(0)).to.eql @initial
        expect(@returns.at(1)).to.eql @entity

  describe 'change', ->
    describe 'given a entity at and no attributes', ->
      beforeEach ->
        @initial = new Entity(name: 'Kat')
        @collection = new Collection(@initial)
        @returns = @collection.change(0, null)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@initial]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct entity at', ->
        expect(@returns.at(0)).to.eql @initial

    describe 'given no entity at and attributes', ->
      beforeEach ->
        @initial = new Entity(name: 'Kat')
        @collection = new Collection(@initial)
        @returns = @collection.change(null, name: 'Julia')

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@initial]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct entity at', ->
        expect(@returns.at(0)).to.eql @initial

    describe 'given a entity at and attributes', ->
      beforeEach ->
        @initial = new Entity(name: 'Kat')
        @collection = new Collection(@initial)
        @returns = @collection.change(0, name: 'Julia')

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [new Entity(name: 'Julia')]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct entity at', ->
        expect(@returns.at(0)).to.eql new Entity(name: 'Julia')

  describe 'remove', ->
    describe 'given no entity at', ->
      beforeEach ->
        @entity0 = new Entity(name: 'Betty')
        @entity1 = new Entity(name: 'Denise')
        @collection = new Collection([@entity0, @entity1])
        @returns = @collection.remove()

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@entity0, @entity1]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct entities at', ->
        expect(@returns.at(0)).to.eql @entity0
        expect(@returns.at(1)).to.eql @entity1

    describe 'given a entity at', ->
      beforeEach ->
        @entity0 = new Entity(name: 'Betty')
        @entity1 = new Entity(name: 'Denise')
        @collection = new Collection([@entity0, @entity1])
        @returns = @collection.remove(0)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@entity1]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct entities at', ->
        expect(@returns.at(0)).to.eql @entity1

  describe 'map', ->
    describe 'given no entities', ->
      beforeEach ->
        @collection = new Collection()

        @p = 'Miss'
        @returns = @collection.map (m, i) ->
          "#{@p} #{m.get('name')} #{i}"
        , this

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql []

    describe 'given two entities', ->
      beforeEach ->
        @entity0 = new Entity(name: 'Tracy')
        @entity1 = new Entity(name: 'Janne')
        @collection = new Collection([@entity0, @entity1])

        @p = 'Miss'
        @returns = @collection.map (m, i) ->
          "#{@p} #{m.get('name')} #{i}"
        , this

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity0, @entity1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql ['Miss Tracy 0', 'Miss Janne 1']

  describe 'toJSON', ->
    describe 'given no entities', ->
      beforeEach ->
        @collection = new Collection()
        @returns = @collection.toJSON()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql []

    describe 'given two entities', ->
      beforeEach ->
        @entity0 = new Entity(name: 'Nia')
        @entity1 = new Entity(name: 'Tia')
        @collection = new Collection([@entity0, @entity1])
        @returns = @collection.toJSON()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity0, @entity1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql [@entity0.toJSON(), @entity1.toJSON()]

  describe 'validate', ->
    describe 'given an invalid entity', ->
      beforeEach ->
        @entity = new Person(name: '')
        @collection = new PersonCollection(@entity)
        @returns = @collection.validate()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be false

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@entity.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given a valid entity', ->
      beforeEach ->
        @entity = new Person(name: 'Frank')
        @collection = new PersonCollection(@entity)
        @returns = @collection.validate()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@entity.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given an incomplete entity', ->
      beforeEach ->
        @entity = new Person()
        @collection = new PersonCollection(@entity)
        @returns = @collection.validate()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expect(@returns.entities).to.eql [@entity.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given both invalid and valid entities', ->
      beforeEach ->
        @entity0 = new Person(name: '')
        @entity1 = new Person(name: 'Frank')
        @collection = new PersonCollection([@entity0, @entity1])
        @returns = @collection.validate()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity0, @entity1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be false

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expected = [@entity0.validate(), @entity1.validate()]
        expect(@returns.entities).to.eql expected

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given both incomplete and valid entities', ->
      beforeEach ->
        @entity0 = new Person()
        @entity1 = new Person(name: 'Frank')
        @collection = new PersonCollection([@entity0, @entity1])
        @returns = @collection.validate()

      it 'has the correct entities', ->
        expect(@collection.entities).to.eql [@entity0, @entity1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct entities', ->
        expected = [@entity0.validate(), @entity1.validate()]
        expect(@returns.entities).to.eql expected

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false
