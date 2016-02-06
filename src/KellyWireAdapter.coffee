I2C = require('i2c')

class KellyWireAdapter
  constructor: (device, address, errorHandler) ->
    @_DEVICE = device
    @_ADDRESS = address
    @_errHandler = errorHandler || (err)->
      console.log "ERR:", err if err?
    @_WIRE = new I2C(address, {device: device})

  writeByte: (value) ->
    @_WIRE.writeByte(value, @_errHandler)

  writeBytes: (cmd, values) ->
    @_WIRE.writeBytes(cmd, values, @_errHandler)

  readByte: (cmd) ->
    if(cmd?)
      return @_WIRE.readBytes(cmd, 1, @_errHandler)[0]
    else
      return @_WIRE.readByte(@_errHandler)

module.exports = KellyWireAdapter
