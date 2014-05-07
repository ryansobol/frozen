expect = require 'expect.js'
{Model} = require '../src/frozen'

class Address extends Model
  validations:
    zipcode:
      required: true

class Person extends Model
  associations:
    address: Address

  validations:
    firstName:
      required: true
      unknown: true
    nickName:
      required: false
    address:
      association: true

describe 'Model', ->
  describe 'constructor', ->
    describe 'given no attributes', ->
      beforeEach ->
        @person = new Person()
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expect(@person.attributes).to.eql {}

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expect(@validated.attributes).to.eql {}

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { firstName: 'Required' }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql {}

    describe 'given no attributes and force validation', ->
      beforeEach ->
        @person = new Person({}, { validate: 'force' })
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expect(@person.attributes).to.eql {}

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: 'force' }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql { firstName: 'Required' }

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be false

      it 'returns the correct validated attributes', ->
        expect(@validated.attributes).to.eql {}

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { firstName: 'Required' }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql {}

    describe 'given valid attributes', ->
      beforeEach ->
        @attrs = { firstName: 'Jim' }
        @person = new Person(@attrs)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expect(@person.attributes).to.eql @attrs

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expect(@validated.attributes).to.eql @attrs

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql {}

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be true

      it 'returns the correct JSON', ->
        expect(@json).to.eql @person.attributes

    describe 'given invalid attributes', ->
      beforeEach ->
        @attrs = { firstName: '' }
        @person = new Person(@attrs)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expect(@person.attributes).to.eql @attrs

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql { firstName: 'Required' }

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be false

      it 'returns the correct validated attributes', ->
        expect(@validated.attributes).to.eql @attrs

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { firstName: 'Required' }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql @person.attributes

    describe 'given invalid attributes without validation', ->
      beforeEach ->
        @attrs = { firstName: '' }
        @person = new Person(@attrs, { validate: false })
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expect(@person.attributes).to.eql @attrs

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: false }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expect(@validated.attributes).to.eql @attrs

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { firstName: 'Required' }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql @person.attributes

    describe 'given no coerseable attributes', ->
      beforeEach ->
        @attrs = { firstName: 'Sierra', address: {} }
        @person = new Person(@attrs)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected = { firstName: 'Sierra', address: new Address() }
        expect(@person.attributes).to.eql expected

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address({}, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql @attrs

    describe 'given no coerseable attributes and force validation', ->
      beforeEach ->
        @attrs = { firstName: 'Sierra', address: {} }
        @person = new Person(@attrs, { validate: 'force' })
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address({}, { validate: 'force' })
        expect(@person.attributes).to.eql expected

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: 'force' }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql { address: { zipcode: 'Required' } }

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be false

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address({}, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql @attrs

    describe 'given valid coerseable attributes', ->
      beforeEach ->
        @attrs = { zipcode: '90120' }
        @person = new Person(firstName: 'Sierra', address: @attrs)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected = { firstName: 'Sierra', address: new Address(@attrs) }
        expect(@person.attributes).to.eql expected

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address(@attrs, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql {}

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be true

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: @attrs }

    describe 'given invalid coerseable attributes', ->
      beforeEach ->
        @attrs = { zipcode: '' }
        @person = new Person(firstName: 'Sierra', address: @attrs)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected = { firstName: 'Sierra', address: new Address(@attrs) }
        expect(@person.attributes).to.eql expected

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql { address: { zipcode: 'Required' } }

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be false

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address(@attrs, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: @attrs }

    describe 'given invalid coerseable attributes without validation', ->
      beforeEach ->
        @attrs = { zipcode: '' }
        @options = { validate: false }
        @person = new Person(firstName: 'Sierra', address: @attrs, @options)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address(@attrs, @options)
        expect(@person.attributes).to.eql expected

      it 'has the correct options', ->
        expect(@person.options).to.eql @options

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address(@attrs, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: @attrs }

    describe 'given no coersed attributes', ->
      beforeEach ->
        @address = new Address()
        @attrs = { firstName: 'Sierra', address: @address }
        @person = new Person(@attrs)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected = { firstName: 'Sierra', address: @address }
        expect(@person.attributes).to.eql expected

      it 'has the correct address', ->
        expect(@person.get('address')).to.be @address

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address({}, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'has the correct validated address', ->
        expect(@validated.get('address')).not.to.be @address

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: {} }

    describe 'given no coersed attributes and force validation', ->
      beforeEach ->
        @address = new Address()
        @attrs = { firstName: 'Sierra', address: @address }
        @person = new Person(@attrs, { validate: 'force' })
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address({}, { validate: 'force' })
        expect(@person.attributes).to.eql expected

      it 'has the correct address', ->
        expect(@person.get('address')).not.to.be @address

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: 'force' }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql { address: { zipcode: 'Required' } }

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be false

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address({}, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'has the correct validated address', ->
        expect(@person.get('address')).not.to.be @address

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: {} }

    describe 'given valid coersed attributes', ->
      beforeEach ->
        @attrs = { zipcode: '90120' }
        @address = new Address(@attrs)
        @person = new Person(firstName: 'Sierra', address: @address)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected = { firstName: 'Sierra', address: @address }
        expect(@person.attributes).to.eql expected

      it 'has the correct address', ->
        expect(@person.get('address')).to.be @address

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address(@attrs, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated address', ->
        expect(@validated.get('address')).not.to.be @address

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql {}

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be true

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: @attrs }

    describe 'given invalid coersed attributes', ->
      beforeEach ->
        @attrs = { zipcode: '' }
        @address = new Address(@attrs)
        @person = new Person(firstName: 'Sierra', address: @address)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected = { firstName: 'Sierra', address: @address }
        expect(@person.attributes).to.eql expected

      it 'has the correct address', ->
        expect(@person.get('address')).to.be @address

      it 'has the correct options', ->
        expect(@person.options).to.eql { validate: true }

      it 'has the correct errors', ->
        expect(@person.errors).to.eql { address: { zipcode: 'Required' } }

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be false

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address(@attrs, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated address', ->
        expect(@validated.get('address')).not.to.be @address

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: @attrs }

    describe 'given invalid coersed attributes without validation', ->
      beforeEach ->
        @attrs = { zipcode: '' }
        @options = { validate: false }
        @address = new Address(@attrs, @options)
        @person = new Person(firstName: 'Sierra', address: @address, @options)
        @validated = @person.validate()
        @json = @person.toJSON()

      it 'has the correct attributes', ->
        expected = { firstName: 'Sierra', address: @address }
        expect(@person.attributes).to.eql expected

      it 'has the correct address', ->
        expect(@person.get('address')).to.be @address

      it 'has the correct options', ->
        expect(@person.options).to.eql @options

      it 'has the correct errors', ->
        expect(@person.errors).to.eql {}

      it 'has the correct validity', ->
        expect(@person.isValid()).to.be true

      it 'returns the correct validated attributes', ->
        expected =
          firstName: 'Sierra'
          address: new Address(@attrs, { validate: 'force' })
        expect(@validated.attributes).to.eql expected

      it 'returns the correct validated address', ->
        expect(@validated.get('address')).not.to.be @address

      it 'returns the correct validated options', ->
        expect(@validated.options).to.eql { validate: 'force' }

      it 'returns the correct validated errors', ->
        expect(@validated.errors).to.eql { address: { zipcode: 'Required' } }

      it 'returns the correct validated validity', ->
        expect(@validated.isValid()).to.be false

      it 'returns the correct JSON', ->
        expect(@json).to.eql { firstName: 'Sierra', address: @attrs }

  describe 'get', ->
    describe 'given attributes', ->
      beforeEach ->
        @person = new Person(firstName: 'Olivia')

      it 'gets the correct value of a known property', ->
        expect(@person.get('firstName')).to.eql 'Olivia'

      it 'gets the correct value of an unknown property', ->
        expect(@person.get('lastName')).to.be undefined

  describe 'set', ->
    describe 'given no attributes', ->
      beforeEach ->
        @person = new Person()
        @returns = @person.set()

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql {}

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: true }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given no attributes and force validation', ->
      beforeEach ->
        @person = new Person()
        @returns = @person.set({}, { validate: 'force' })

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql {}

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: 'force' }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql { firstName: 'Required' }

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given valid attributes', ->
      beforeEach ->
        @person = new Person()
        @returns = @person.set(firstName: 'Amy')

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { firstName: 'Amy' }

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: true }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given invalid attributes', ->
      beforeEach ->
        @person = new Person()
        @returns = @person.set(firstName: '')

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { firstName: '' }

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: true }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql { firstName: 'Required' }

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given invalid attributes without validation', ->
      beforeEach ->
        @person = new Person()
        @returns = @person.set(firstName: '', { validate: false })

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { firstName: '' }

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: false }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given valid coerseable attributes', ->
      beforeEach ->
        @attrs = { zipcode: '90210' }
        @person = new Person()
        @returns = @person.set(address: @attrs)

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { address: new Address(@attrs) }

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: true }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given no coersed attributes', ->
      beforeEach ->
        @address = new Address()
        @person = new Person()
        @returns = @person.set(address: @address)

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { address: @address }

      it 'returns the correct validated address', ->
        expect(@returns.get('address')).to.be @address

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: true }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given no coersed attributes and force validation', ->
      beforeEach ->
        @address = new Address()
        @person = new Person(firstName: 'Amy')
        @returns = @person.set(address: @address, { validate: 'force' })

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).not.to.eql { address: @address }

      it 'returns the correct validated address', ->
        expect(@returns.get('address')).not.to.be @address

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: 'force' }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql { address: { zipcode: 'Required' }}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given valid coersed attributes', ->
      beforeEach ->
        @attrs = { zipcode: '90210' }
        @address = new Address(@attrs)
        @person = new Person()
        @returns = @person.set(address: @address)

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { address: @address }

      it 'returns the correct validated address', ->
        expect(@returns.get('address')).to.be @address

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: true }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true

    describe 'given invalid coersed attributes', ->
      beforeEach ->
        @attrs = { zipcode: '' }
        @address = new Address(@attrs)
        @person = new Person()
        @returns = @person.set(address: @address)

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { address: @address }

      it 'returns the correct validated address', ->
        expect(@returns.get('address')).to.be @address

      it 'returns the correct options', ->
        expect(@returns.options).to.eql { validate: true }

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql { address: { zipcode: 'Required' }}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be false

    describe 'given invalid coersed attributes without validation', ->
      beforeEach ->
        @attrs = { zipcode: '' }
        @options = { validate: false }
        @address = new Address(@attrs, @options)
        @person = new Person()
        @returns = @person.set(address: @address, @options)

      it 'returns the correct object', ->
        expect(@returns).not.to.be @person

      it 'returns the correct attributes', ->
        expect(@returns.attributes).to.eql { address: @address }

      it 'returns the correct validated address', ->
        expect(@returns.get('address')).to.be @address

      it 'returns the correct options', ->
        expect(@returns.options).to.eql @options

      it 'returns the correct errors', ->
        expect(@returns.errors).to.eql {}

      it 'returns the correct validity', ->
        expect(@returns.isValid()).to.be true
