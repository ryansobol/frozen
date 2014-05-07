expect = require 'expect.js'
{Collection, Model} = require '../src/frozen'

class Person extends Model
  validations:
    name:
      required: true

class PersonCollection extends Collection
  model: Person

describe 'Collection', ->
  describe 'constructor', ->
    describe 'given no object', ->
      beforeEach ->
        @collection = new Collection()

      it 'has the correct models', ->
        expect(@collection.models).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'has the correct models at', ->
        expect(@collection.at(0)).to.eql undefined

    describe 'given an object', ->
      beforeEach ->
        @object = { name: 'Jim' }
        @collection = new Collection(@object)

      it 'has the correct models', ->
        expect(@collection.models).to.eql [new Model(@object)]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct models at', ->
        expect(@collection.at(0)).to.eql new Model(@object)
        expect(@collection.at(1)).to.eql undefined

    describe 'given two objects', ->
      beforeEach ->
        @object0 = { name: 'Jim' }
        @object1 = { name: 'Ted' }
        @collection = new Collection([@object0, @object1])

      it 'has the correct models', ->
        expect(@collection.models).to.eql [new Model(@object0), new Model(@object1)]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct models at', ->
        expect(@collection.at(0)).to.eql new Model(@object0)
        expect(@collection.at(1)).to.eql new Model(@object1)
        expect(@collection.at(2)).to.eql undefined

    describe 'given a model', ->
      beforeEach ->
        @model = new Model(name: 'Jim')
        @collection = new Collection(@model)

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct models at', ->
        expect(@collection.at(0)).to.eql @model
        expect(@collection.at(1)).to.eql undefined

    describe 'given two models', ->
      beforeEach ->
        @model0 = new Model(name: 'Jim')
        @model1 = new Model(name: 'Ted')
        @collection = new Collection([@model0, @model1])

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model0, @model1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct models at', ->
        expect(@collection.at(0)).to.eql @model0
        expect(@collection.at(1)).to.eql @model1
        expect(@collection.at(2)).to.eql undefined

  describe 'insert', ->
    describe 'given an index of 0', ->
      beforeEach ->
        @index = 0

      describe 'given no object', ->
        beforeEach ->
          @initial = new Model(name: 'Bob')
          @collection = new Collection(@initial)
          @returns = @collection.insert(@index)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct models', ->
          expect(@returns.models).to.eql [new Model(), @initial]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct models at', ->
          expect(@returns.at(0)).to.eql new Model()
          expect(@returns.at(1)).to.eql @initial

      describe 'given an object', ->
        beforeEach ->
          @initial = new Model(name: 'Bob')
          @collection = new Collection(@initial)
          @object = { name: 'Tom' }
          @returns = @collection.insert(@index, @object)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct models', ->
          expect(@returns.models).to.eql [new Model(@object), @initial]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct models at', ->
          expect(@returns.at(0)).to.eql new Model(@object)
          expect(@returns.at(1)).to.eql @initial

      describe 'given a model', ->
        beforeEach ->
          @initial = new Model(name: 'Bob')
          @collection = new Collection(@initial)
          @model = new Model(name: 'Tom')
          @returns = @collection.insert(@index, @model)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct models', ->
          expect(@returns.models).to.eql [@model, @initial]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct models at', ->
          expect(@returns.at(0)).to.eql @model
          expect(@returns.at(1)).to.eql @initial

    describe 'given an index of 1', ->
      beforeEach ->
        @index = 1

      describe 'given no object', ->
        beforeEach ->
          @initial = new Model(name: 'Bob')
          @collection = new Collection(@initial)
          @returns = @collection.insert(@index)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct models', ->
          expect(@returns.models).to.eql [@initial, new Model()]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct models at', ->
          expect(@returns.at(0)).to.eql @initial
          expect(@returns.at(1)).to.eql new Model()

      describe 'given an object', ->
        beforeEach ->
          @initial = new Model(name: 'Bob')
          @collection = new Collection(@initial)
          @object = { name: 'Tom' }
          @returns = @collection.insert(@index, @object)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct models', ->
          expect(@returns.models).to.eql [@initial, new Model(@object)]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct models at', ->
          expect(@returns.at(0)).to.eql @initial
          expect(@returns.at(1)).to.eql new Model(@object)

      describe 'given a model', ->
        beforeEach ->
          @initial = new Model(name: 'Bob')
          @collection = new Collection(@initial)
          @model = new Model(name: 'Tom')
          @returns = @collection.insert(@index, @model)

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct models', ->
          expect(@returns.models).to.eql [@initial, @model]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct models at', ->
          expect(@returns.at(0)).to.eql @initial
          expect(@returns.at(1)).to.eql @model

  describe 'push', ->
    describe 'given no object', ->
      beforeEach ->
        @initial = new Model(name: 'Bob')
        @collection = new Collection(@initial)
        @returns = @collection.push()

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@initial, new Model()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct models at', ->
        expect(@returns.at(0)).to.eql @initial
        expect(@returns.at(1)).to.eql new Model()

    describe 'given an object', ->
      beforeEach ->
        @initial = new Model(name: 'Bob')
        @collection = new Collection(@initial)
        @object = { name: 'Tom' }
        @returns = @collection.push(@object)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@initial, new Model(@object)]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct models at', ->
        expect(@returns.at(0)).to.eql @initial
        expect(@returns.at(1)).to.eql new Model(@object)

    describe 'given a model', ->
      beforeEach ->
        @initial = new Model(name: 'Bob')
        @collection = new Collection(@initial)
        @model = new Model(name: 'Tom')
        @returns = @collection.push(@model)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@initial, @model]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct models at', ->
        expect(@returns.at(0)).to.eql @initial
        expect(@returns.at(1)).to.eql @model

  describe 'change', ->
    describe 'given a model at and no attributes', ->
      beforeEach ->
        @initial = new Model(name: 'Kat')
        @collection = new Collection(@initial)
        @returns = @collection.change(0, null)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@initial]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct model at', ->
        expect(@returns.at(0)).to.eql @initial

    describe 'given no model at and attributes', ->
      beforeEach ->
        @initial = new Model(name: 'Kat')
        @collection = new Collection(@initial)
        @returns = @collection.change(null, name: 'Julia')

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@initial]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct model at', ->
        expect(@returns.at(0)).to.eql @initial

    describe 'given a model at and attributes', ->
      beforeEach ->
        @initial = new Model(name: 'Kat')
        @collection = new Collection(@initial)
        @returns = @collection.change(0, name: 'Julia')

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [new Model(name: 'Julia')]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct model at', ->
        expect(@returns.at(0)).to.eql new Model(name: 'Julia')

  describe 'remove', ->
    describe 'given no model at', ->
      beforeEach ->
        @model0 = new Model(name: 'Betty')
        @model1 = new Model(name: 'Denise')
        @collection = new Collection([@model0, @model1])
        @returns = @collection.remove()

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model0, @model1]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct models at', ->
        expect(@returns.at(0)).to.eql @model0
        expect(@returns.at(1)).to.eql @model1

    describe 'given a model at', ->
      beforeEach ->
        @model0 = new Model(name: 'Betty')
        @model1 = new Model(name: 'Denise')
        @collection = new Collection [@model0, @model1]
        @returns = @collection.remove(0)

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model1]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct models at', ->
        expect(@returns.at(0)).to.eql @model1

  describe 'map', ->
    describe 'given no models', ->
      beforeEach ->
        @collection = new Collection()

        @p = 'Miss'
        @returns = @collection.map ((m, i) -> "#{@p} #{m.get('name')} #{i}"), @

      it 'has the correct models', ->
        expect(@collection.models).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql []

    describe 'given two models', ->
      beforeEach ->
        @model0 = new Model(name: 'Tracy')
        @model1 = new Model(name: 'Janne')
        @collection = new Collection([@model0, @model1])

        @p = 'Miss'
        @returns = @collection.map ((m, i) -> "#{@p} #{m.get('name')} #{i}"), @

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model0, @model1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql ['Miss Tracy 0', 'Miss Janne 1']

  describe 'toJSON', ->
    describe 'given no models', ->
      beforeEach ->
        @collection = new Collection()
        @returns = @collection.toJSON()

      it 'has the correct models', ->
        expect(@collection.models).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql []

    describe 'given two models', ->
      beforeEach ->
        @model0 = new Model(name: 'Nia')
        @model1 = new Model(name: 'Tia')
        @collection = new Collection([@model0, @model1])
        @returns = @collection.toJSON()

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model0, @model1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'returns an array', ->
        expect(@returns instanceof Array).to.be true

      it 'returns the correct data', ->
        expect(@returns).to.eql [@model0.toJSON(), @model1.toJSON()]

  describe 'validate', ->
    describe 'given an invalid model', ->
      beforeEach ->
        @model = new Person(name: '')
        @collection = new PersonCollection(@model)
        @returns = @collection.validate()

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be false

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given a valid model', ->
      beforeEach ->
        @model = new Person(name: 'Frank')
        @collection = new PersonCollection(@model)
        @returns = @collection.validate()

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given an incomplete model', ->
      beforeEach ->
        @model = new Person()
        @collection = new PersonCollection(@model)
        @returns = @collection.validate()

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given both invalid and valid models', ->
      beforeEach ->
        @model0 = new Person(name: '')
        @model1 = new Person(name: 'Frank')
        @collection = new PersonCollection([@model0, @model1])
        @returns = @collection.validate()

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model0, @model1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be false

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model0.validate(), @model1.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given both incomplete and valid models', ->
      beforeEach ->
        @model0 = new Person()
        @model1 = new Person(name: 'Frank')
        @collection = new PersonCollection([@model0, @model1])
        @returns = @collection.validate()

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model0, @model1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

      it 'has the correct validity', ->
        expect(@collection.isValid()).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model0.validate(), @model1.validate()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 2

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false
