expect = require 'expect.js'
{Model, Validation} = require '../src/frozen'

class Address extends Model
  validations:
    zipcode:
      required: true

describe 'Validation', ->
  describe 'required', ->
    describe 'given a valid value', ->
      beforeEach ->
        @returns = Validation.required('firstName', 'Jamie', true)

      it 'returns the correct message', ->
        expect(@returns).to.eql undefined

    describe 'given an invalid value', ->
      beforeEach ->
        @returns = Validation.required('firstName', '', true)

      it 'returns the correct message', ->
        expect(@returns).to.eql 'Required'

    describe 'given an invalid value and a message', ->
      beforeEach ->
        @returns = Validation.required('firstName', ' ', message: 'Invalid')

      it 'returns the correct message', ->
        expect(@returns).to.eql 'Invalid'

    describe 'given no value', ->
      beforeEach ->
        @returns = Validation.required('firstName', null, true)

      it 'returns the correct message', ->
        expect(@returns).to.eql 'Required'

  describe 'coersion', ->
    describe 'given a valid value', ->
      beforeEach ->
        @returns = Validation.coersion('address', new Address(zipcode: '90210'))

      it 'returns the correct message', ->
        expect(@returns).to.eql undefined

    describe 'given an invalid value', ->
      beforeEach ->
        @returns = Validation.coersion('address', new Address(zipcode: ''))

      it 'returns the correct message', ->
        expect(@returns).to.eql { zipcode: 'Required' }

    describe 'given no value', ->
      beforeEach ->
        @returns = Validation.coersion('address', null)

      it 'returns the correct message', ->
        expect(@returns).to.eql undefined