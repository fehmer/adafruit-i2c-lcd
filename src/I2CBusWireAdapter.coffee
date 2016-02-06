I2C = require('i2c-bus')

class I2CBusWireAdapter
  constructor: (device, address) ->
    if not (typeof device is  'number')
      throw new Error('parameter device has to be the number of the device, not a path or device name. e.g. 1 instead of /dev/i2c-1 or i2c-1');
    
    @_DEVICE = device
    @_ADDRESS = address
    @_WIRE = I2C.openSync(device)

  writeByte: (value) ->
    @_WIRE.sendByteSync(@_ADDRESS, value)

  writeBytes: (cmd, values) ->
    unless Buffer.isBuffer(values) then values = new Buffer(values)
    @_WIRE.writeI2cBlockSync(@_ADDRESS, cmd, values.length, values)

  readByte: (cmd) ->
    if cmd?
      return @_WIRE.readByteSync(@_ADDRESS, cmd)
    else
      return @_WIRE.receiveByteSync(@_ADDRESS)

module.exports = I2CBusWireAdapter