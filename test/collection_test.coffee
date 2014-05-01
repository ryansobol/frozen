expect = require 'expect.js'
{Collection, Model} = require '../src/frozen'

describe 'Collection', ->
  describe 'constructor', ->
    describe 'given no object', ->
      beforeEach ->
        @collection = new Collection()

      it 'has the correct models', ->
        expect(@collection.models).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

    describe 'given an object', ->
      beforeEach ->
        @object = firstName: 'Jim'
        @collection = new Collection @object

      it 'has the correct models', ->
        expect(@collection.models).to.eql [new Model @object]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

    describe 'given two objects', ->
      beforeEach ->
        @object0 = firstName: 'Jim'
        @object1 = firstName: 'Ted'
        @collection = new Collection [@object0, @object1]

      it 'has the correct models', ->
        expect(@collection.models).to.eql [new Model(@object0), new Model(@object1)]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

    describe 'given a model', ->
      beforeEach ->
        @model = new Model firstName: 'Jim'
        @collection = new Collection @model

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 1

    describe 'given two models', ->
      beforeEach ->
        @model0 = new Model firstName: 'Jim'
        @model1 = new Model firstName: 'Ted'
        @collection = new Collection [@model0, @model1]

      it 'has the correct models', ->
        expect(@collection.models).to.eql [@model0, @model1]

      it 'has the correct length', ->
        expect(@collection.length).to.eql 2

  describe 'add', ->
    describe 'given no object', ->
      beforeEach ->
        @collection = new Collection()
        @returns = @collection.add()

      it 'has the correct models', ->
        expect(@collection.models).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'returns an instance of itself', ->
        expect(@returns instanceof Collection).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [new Model()]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

    describe 'given an object', ->
      beforeEach ->
        @object = firstName: 'Tom'
        @collection = new Collection()
        @returns = @collection.add @object

      it 'has the correct models', ->
        expect(@collection.models).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'returns an instance of itself', ->
        expect(@returns instanceof Collection).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [new Model @object]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

    describe 'given a model', ->
      beforeEach ->
        @model = new Model firstName: 'Tom'
        @collection = new Collection()
        @returns = @collection.add @model

      it 'has the correct models', ->
        expect(@collection.models).to.eql []

      it 'has the correct length', ->
        expect(@collection.length).to.eql 0

      it 'returns an instance of itself', ->
        expect(@returns instanceof Collection).to.be true

      it 'returns a different object', ->
        expect(@returns).not.to.be @collection

      it 'returns the correct models', ->
        expect(@returns.models).to.eql [@model]

      it 'returns the correct length', ->
        expect(@returns.length).to.eql 1

  describe 'change', ->
    beforeEach ->
      @object0 = firstName: 'Alice'
      @object1 = firstName: 'Katherine'
      @collection = new Collection [@object0, @object1]
      @returns = @collection.change(0, firstName: 'Julia')

    it 'has the correct models', ->
      expect(@collection.models).to.eql [new Model(@object0), new Model(@object1)]

    it 'has the correct length', ->
      expect(@collection.length).to.eql 2

    it 'returns an instance of itself', ->
      expect(@returns instanceof Collection).to.be true

    it 'returns a different object', ->
      expect(@returns).not.to.be @collection

    it 'returns the correct models', ->
      expect(@returns.models).to.eql [new Model(firstName: 'Julia'), new Model(@object1)]

    it 'returns the correct length', ->
      expect(@returns.length).to.eql 2

  describe 'destroy', ->
    beforeEach ->
      @object0 = firstName: 'Betty'
      @object1 = firstName: 'Denise'
      @collection = new Collection [@object0, @object1]
      @returns = @collection.destroy(0)

    it 'has the correct models', ->
      expect(@collection.models).to.eql [new Model(@object0), new Model(@object1)]

    it 'has the correct length', ->
      expect(@collection.length).to.eql 2

    it 'returns an instance of itself', ->
      expect(@returns instanceof Collection).to.be true

    it 'returns a different object', ->
      expect(@returns).not.to.be @collection

    it 'returns the correct models', ->
      expect(@returns.models).to.eql [new Model(@object1)]

    it 'returns the correct length', ->
      expect(@returns.length).to.eql 1

  describe 'map', ->
    beforeEach ->
      @object0 = firstName: 'Tracy'
      @object1 = firstName: 'Roberta'
      @collection = new Collection [@object0, @object1]

      @prefix = 'Miss'
      @returns = @collection.map (profile, index) =>
        "#{@prefix} #{profile.get('firstName')} #{index}"

    it 'has the correct models', ->
      expect(@collection.models).to.eql [new Model(@object0), new Model(@object1)]

    it 'has the correct length', ->
      expect(@collection.length).to.eql 2

    it 'returns an array', ->
      expect(@returns instanceof Array).to.be true

    it 'returns the correct data', ->
      expect(@returns).to.eql ['Miss Tracy 0', 'Miss Roberta 1']

    it 'returns the correct length', ->
      expect(@returns.length).to.eql 2

  describe 'toJSON', ->
    beforeEach ->
      @object0 = { firstName: 'Nia' }
      @object1 = { firstName: 'Tia' }
      @collection = new Collection [@object0, @object1]
      @returns = @collection.toJSON()

    it 'has the correct models', ->
      expect(@collection.models).to.eql [new Model(@object0), new Model(@object1)]

    it 'has the correct length', ->
      expect(@collection.length).to.eql 2

    it 'returns an array', ->
      expect(@returns instanceof Array).to.be true

    it 'returns the correct data', ->
      expect(@returns).to.eql [@object0, @object1]

    it 'returns the correct length', ->
      expect(@returns.length).to.eql 2

  describe 'validate', ->
    describe 'given a collection and a model with validations', ->
      beforeEach ->
        class FrankModel extends Model
          validations:
            firstName:
              required: true

        class FrankCollection extends Collection
          model: FrankModel

        @FrankModel = FrankModel
        @FrankCollection = FrankCollection

      describe 'given an invalid model', ->
        beforeEach ->
          @model = new @FrankModel firstName: ''
          @collection = new @FrankCollection @model
          @returns = @collection.validate()

        it 'has the correct models', ->
          expect(@collection.models).to.eql [@model]

        it 'has the correct length', ->
          expect(@collection.length).to.eql 1

        it 'has the correct validity', ->
          expect(@collection.isValid()).to.be false

        it 'returns an instance of itself', ->
          expect(@returns instanceof Collection).to.be true

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
          @model = new @FrankModel firstName: 'Frank'
          @collection = new @FrankCollection @model
          @returns = @collection.validate()

        it 'has the correct models', ->
          expect(@collection.models).to.eql [@model]

        it 'has the correct length', ->
          expect(@collection.length).to.eql 1

        it 'has the correct validity', ->
          expect(@collection.isValid()).to.be true

        it 'returns an instance of itself', ->
          expect(@returns instanceof Collection).to.be true

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
          @model = new @FrankModel()
          @collection = new @FrankCollection @model
          @returns = @collection.validate()

        it 'has the correct models', ->
          expect(@collection.models).to.eql [@model]

        it 'has the correct length', ->
          expect(@collection.length).to.eql 1

        it 'has the correct validity', ->
          expect(@collection.isValid()).to.be true

        it 'returns an instance of itself', ->
          expect(@returns instanceof Collection).to.be true

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
          @model0 = new @FrankModel firstName: ''
          @model1 = new @FrankModel firstName: 'Frank'
          @collection = new @FrankCollection [@model0, @model1]
          @returns = @collection.validate()

        it 'has the correct models', ->
          expect(@collection.models).to.eql [@model0, @model1]

        it 'has the correct length', ->
          expect(@collection.length).to.eql 2

        it 'has the correct validity', ->
          expect(@collection.isValid()).to.be false

        it 'returns an instance of itself', ->
          expect(@returns instanceof Collection).to.be true

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
          @model0 = new @FrankModel()
          @model1 = new @FrankModel firstName: 'Frank'
          @collection = new @FrankCollection [@model0, @model1]
          @returns = @collection.validate()

        it 'has the correct models', ->
          expect(@collection.models).to.eql [@model0, @model1]

        it 'has the correct length', ->
          expect(@collection.length).to.eql 2

        it 'has the correct validity', ->
          expect(@collection.isValid()).to.be true

        it 'returns an instance of itself', ->
          expect(@returns instanceof Collection).to.be true

        it 'returns a different object', ->
          expect(@returns).not.to.be @collection

        it 'returns the correct models', ->
          expect(@returns.models).to.eql [@model0.validate(), @model1.validate()]

        it 'returns the correct length', ->
          expect(@returns.length).to.eql 2

        it 'returns the correct validity', ->
          expect(@returns.isValid()).to.be false
