expect = require 'expect.js'
{Model} = require '../src/frozen'

describe 'Model', ->
  describe '.constructor', ->
    describe 'given no object', ->
      beforeEach ->
        @model = new Model()

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql {}

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

    describe 'given an object', ->
      beforeEach ->
        @object = firstName: 'Jim'
        @model = new Model @object

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

    describe 'given an invalid object', ->
      beforeEach ->
        class FelixModel extends Model
          firstNameError: (value) -> 'Guess again' unless value is 'Felix'

        @object = firstName: 'Ginny'
        @model = new FelixModel @object

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql { firstName: 'Guess again' }

    describe 'given a valid object', ->
      beforeEach ->
        class FelixModel extends Model
          firstNameError: (value) -> 'Guess again' unless value is 'Felix'

        @object = firstName: 'Felix'
        @model = new FelixModel @object

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

    describe 'given a subclass with faux error checking', ->
      beforeEach ->
        class FelixModel extends Model
          firstNameError: (value) -> null

        @object = firstName: 'Ginny'
        @model = new FelixModel @object

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

  describe '.get', ->
    beforeEach ->
      @model = new Model firstName: 'Olivia'

    it 'gets the correct value of a known property', ->
      expect(@model.get('firstName')).to.eql 'Olivia'

    it 'gets the correct value of an unknown property', ->
      expect(@model.get('last_name')).to.be undefined

  describe '.set', ->
    beforeEach ->
      @model = new Model()
      @returns = @model.set('firstName', 'Amy')

    it 'has the correct attributes', ->
      expect(@model.attributes).to.eql {}

    it 'has the correct errors', ->
      expect(@model.errors).to.eql {}

    it 'returns an instance of itself', ->
      expect(@returns instanceof Model).to.be true

    it 'returns the correct attributes', ->
      expect(@returns.attributes).to.eql firstName: 'Amy'

    it 'returns the correct errors', ->
      expect(@returns.errors).to.eql {}

  describe '.toJSON', ->
    beforeEach ->
      @object = firstName: 'David'
      @model = new Model @object
      @returns = @model.toJSON()

    it 'has the correct attributes', ->
      expect(@model.attributes).to.eql @object

    it 'has the correct errors', ->
      expect(@model.errors).to.eql {}

    it 'returns its attributes', ->
      expect(@returns).to.eql @model.attributes

  describe '.validate', ->
    describe 'given an invalid object', ->
      beforeEach ->
        class LisaModel extends Model
          validProps: ['firstName']
          firstNameError: (value) -> 'Guess again' unless value is 'Lisa'

        @object = { firstName: 'Ginny' }
        @model = new LisaModel @object
        @returns = @model.validate()

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql { firstName: 'Guess again' }

      it 'has the correct validity', ->
        expect(@model.isValid()).to.be false

      it 'returns an instance of itself', ->
        expect(@returns instanceof Model).to.be true

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql @object

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql { firstName: 'Guess again' }

    describe 'given a valid object', ->
      beforeEach ->
        class LisaModel extends Model
          validProps: ['firstName']
          firstNameError: (value) -> 'Guess again' unless value is 'Lisa'

        @object = { firstName: 'Lisa' }
        @model = new LisaModel @object
        @returns = @model.validate()

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@model.isValid()).to.be true

      it 'returns an instance of itself', ->
        expect(@returns instanceof Model).to.be true

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql @object

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

    describe 'given a blank object', ->
      beforeEach ->
        class LisaModel extends Model
          validProps: ['firstName']
          firstNameError: (value) -> 'Guess again' unless value is 'Lisa'

        @object = {}
        @model = new LisaModel @object
        @returns = @model.validate()

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@model.isValid()).to.be true

      it 'returns an instance of itself', ->
        expect(@returns instanceof Model).to.be true

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { firstName: '' }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql { firstName: 'Guess again' }
