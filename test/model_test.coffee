expect = require 'expect.js'
{Model} = require '../src/frozen'

describe 'Model', ->
  describe 'constructor', ->
    describe 'given no attributes', ->
      beforeEach ->
        @model = new Model()

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql {}

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

    describe 'given attributes', ->
      beforeEach ->
        @attrs = firstName: 'Jim'
        @model = new Model @attrs

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @attrs

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

    describe 'given a model with a known validator', ->
      beforeEach ->
        class @FelixModel extends Model
          validations:
            firstName:
              required: true

      describe 'given no attributes', ->
        beforeEach ->
          @model = new @FelixModel()

        it 'has the correct attributes', ->
          expect(@model.attributes).to.eql {}

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

      describe 'given invalid attributes', ->
        beforeEach ->
          @attrs = firstName: ''
          @model = new @FelixModel @attrs

        it 'has the correct attributes', ->
          expect(@model.attributes).to.eql @attrs

        it 'has the correct errors', ->
          expect(@model.errors).to.eql { firstName: 'Required' }

      describe 'given valid attributes', ->
        beforeEach ->
          @attrs = firstName: 'Felix'
          @model = new @FelixModel @attrs

        it 'has the correct attributes', ->
          expect(@model.attributes).to.eql @attrs

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

    describe 'given a model with an unknown validator', ->
      beforeEach ->
        class @GinnyModel extends Model
          validations:
            firstName:
              unknown: true

      describe 'given attributes', ->
        beforeEach ->
          @attrs = firstName: ''
          @model = new @GinnyModel @attrs

        it 'has the correct attributes', ->
          expect(@model.attributes).to.eql @attrs

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

    describe 'given a model with a coersion', ->
      beforeEach ->
        class AddressModel extends Model
        class PersonModel extends Model
          coersions:
            address: AddressModel

        @AddressModel = AddressModel
        @PersonModel = PersonModel

      describe 'given coerseable attributes', ->
        beforeEach ->
          @address = zipcode: '90120'
          @person = new @PersonModel address: @address

        it 'has the correct attribute', ->
          expected = { address: new @AddressModel @address }
          expect(@person.attributes).to.eql expected

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

      describe 'given coersed attributes', ->
        beforeEach ->
          @address = zipcode: '90120'
          @person = new @PersonModel address: new @AddressModel @address

        it 'has the correct attribute', ->
          expected = { address: new @AddressModel @address }
          expect(@person.attributes).to.eql expected

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

      describe 'given no attributes', ->
        beforeEach ->
          @person = new @PersonModel()

        it 'has the correct attribute', ->
          expect(@person.attributes).to.eql {}

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

  describe 'get', ->
    beforeEach ->
      @model = new Model firstName: 'Olivia'

    it 'gets the correct value of a known property', ->
      expect(@model.get('firstName')).to.eql 'Olivia'

    it 'gets the correct value of an unknown property', ->
      expect(@model.get('last_name')).to.be undefined

  describe 'set', ->
    describe 'given no attributes', ->
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

    describe 'given attributes', ->
      beforeEach ->
        @attrs = { firstName: 'Jolene' }
        @model = new Model @attrs
        @returns = @model.set('firstName', 'Amy')

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @attrs

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

      it 'returns an instance of itself', ->
        expect(@returns instanceof Model).to.be true

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql firstName: 'Amy'

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

    describe 'given a model with coersion', ->
      beforeEach ->
        class AddressModel extends Model
        class PersonModel extends Model
          coersions:
            address: AddressModel

        @AddressModel = AddressModel
        @PersonModel = PersonModel

      describe 'given coerseable attributes', ->
        beforeEach ->
          @address = { zipcode: '90210' }
          @person = new @PersonModel()
          @returns = @person.set('address', @address)

        it 'has the correct attributes', ->
          expect(@person.attributes).to.eql {}

        it 'has the correct errors', ->
          expect(@person.errors).to.eql {}

        it 'returns an instance of itself', ->
          expect(@returns instanceof Model).to.be true

        it 'returns the correct attributes', ->
          expected = { address: new @AddressModel @address }
          expect(@returns.attributes).to.eql

        it 'returns the correct errors', ->
          expect(@returns.errors).to.eql {}

  describe 'toJSON', ->
    describe 'given no attributes', ->
      beforeEach ->
        @model = new Model()
        @returns = @model.toJSON()

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql {}

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

      it 'returns the correct attributes', ->
        expect(@returns).to.eql {}

    describe 'given attributes', ->
      beforeEach ->
        @object = firstName: 'David'
        @model = new Model @object
        @returns = @model.toJSON()

      it 'has the correct attributes', ->
        expect(@model.attributes).to.eql @object

      it 'has the correct errors', ->
        expect(@model.errors).to.eql {}

      it 'returns the correct attributes', ->
        expect(@returns).to.eql @model.attributes

    describe 'given a model with coersion', ->
      beforeEach ->
        class AddressModel extends Model
        class PersonModel extends Model
          coersions:
            address: AddressModel

        @AddressModel = AddressModel
        @PersonModel = PersonModel

      describe 'given coerseable and uncoerseable attributes', ->
        beforeEach ->
          @address = { zipcode: '90210' }
          @attrs = { firstName: 'Alex', address: @address }
          @person = new @PersonModel @attrs
          @returns = @person.toJSON()

        it 'has the correct attributes', ->
          expected = { firstName: 'Alex', address: new @AddressModel @address }
          expect(@person.attributes).to.eql expected

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

        it 'returns the correct attributes', ->
          expect(@returns).to.eql @attrs

  describe 'validate', ->
    describe 'given a model with validation', ->
      beforeEach ->
        class @LisaModel extends Model
          validations:
            firstName:
              required: true

      describe 'given invalid attributes', ->
        beforeEach ->
          @attrs = { firstName: '' }
          @model = new @LisaModel @attrs
          @returns = @model.validate()

        it 'has the correct attributes', ->
          expect(@model.attributes).to.eql @attrs

        it 'has the correct errors', ->
          expect(@model.errors).to.eql { firstName: 'Required' }

        it 'has the correct validity', ->
          expect(@model.isValid()).to.be false

        it 'returns an instance of itself', ->
          expect(@returns instanceof Model).to.be true

        it 'returns the correct validity', ->
          expect(@returns.isValid()).to.be false

        it 'returns the correct attributes', ->
          expect(@returns.attributes).to.eql @attrs

        it 'returns the correct errors', ->
          expect(@returns.errors).to.eql { firstName: 'Required' }

      describe 'given valid attributes', ->
        beforeEach ->
          @attrs = { firstName: 'Lisa' }
          @model = new @LisaModel @attrs
          @returns = @model.validate()

        it 'has the correct attributes', ->
          expect(@model.attributes).to.eql @attrs

        it 'has the correct errors', ->
          expect(@model.errors).to.eql {}

        it 'has the correct validity', ->
          expect(@model.isValid()).to.be true

        it 'returns an instance of itself', ->
          expect(@returns instanceof Model).to.be true

        it 'returns the correct validity', ->
          expect(@returns.isValid()).to.be true

        it 'returns the correct attributes', ->
          expect(@returns.attributes).to.eql @attrs

        it 'returns the correct errors', ->
          expect(@returns.errors).to.eql {}

      describe 'given no attributes', ->
        beforeEach ->
          @model = new @LisaModel()
          @returns = @model.validate()

        it 'has the correct attributes', ->
          expect(@model.attributes).to.eql {}

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
          expect(@returns.errors).to.eql { firstName: 'Required' }
