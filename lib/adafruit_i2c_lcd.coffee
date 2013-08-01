#Port expander registers
MCP23017_IOCON_BANK0    = 0x0A  #IOCON when Bank 0 active
MCP23017_IOCON_BANK1    = 0x15  #IOCON when Bank 1 active
#These are register addresses when in Bank 1 only:
MCP23017_GPIOA          = 0x09
MCP23017_IODIRB         = 0x10
MCP23017_GPIOB          = 0x19

#LCD Commands
LCD_CLEARDISPLAY        = 0x01
LCD_RETURNHOME          = 0x02
LCD_ENTRYMODESET        = 0x04
LCD_DISPLAYCONTROL      = 0x08
LCD_CURSORSHIFT         = 0x10
LCD_FUNCTIONSET         = 0x20
LCD_SETCGRAMADDR        = 0x40
LCD_SETDDRAMADDR        = 0x80

#Flags for display on/off control
LCD_DISPLAYON           = 0x04
LCD_DISPLAYOFF          = 0x00
LCD_CURSORON            = 0x02
LCD_CURSOROFF           = 0x00
LCD_BLINKON             = 0x01
LCD_BLINKOFF            = 0x00

#Flags for display entry mode
LCD_ENTRYRIGHT          = 0x00
LCD_ENTRYLEFT           = 0x02
LCD_ENTRYSHIFTINCREMENT = 0x01
LCD_ENTRYSHIFTDECREMENT = 0x00

#Flags for display/cursor shift
LCD_DISPLAYMOVE = 0x08
LCD_CURSORMOVE  = 0x00
LCD_MOVERIGHT   = 0x04
LCD_MOVELEFT    = 0x00

flip = [0x00, 0x10, 0x08, 0x18,
		0x04, 0x14, 0x0C, 0x1C,
		0x02, 0x12, 0x0A, 0x1A,
		0x06, 0x16, 0x0E, 0x1E]
pollables = [ LCD_CLEARDISPLAY, LCD_RETURNHOME ]

EventEmitter = require('events').EventEmitter
I2C = require('i2c')

errorHandler = (err)->
	console.log "ERR:", err if err?


class Plate extends EventEmitter
	constructor: (device, address, debug, pollInterval) ->
		@ADDRESS = address
		@PORTA = 0
		@PORTB = 0
		@DDRB = 0x10
		@WIRE = new I2C(@ADDRESS, {device: device})
		@DEBUG = debug || false
		pollInterval=100 if not pollInterval?
		@init()
		@BSTATE = 0
		poll = setInterval ()=>
			cur=@buttonState()
			if cur != @BSTATE
				key=@BSTATE ^ cur
				@emit 'button_change', key
				if cur<@BSTATE
					@emit 'button_up', key
				else
					@emit 'button_down', key
				@BSTATE = cur
		pollInterval
		
	colors:
		OFF: 0x00
		RED: 0x01
		GREEN: 0x02
		BLUE: 0x04
		YELLOW: 0x03
		TEAL: 0x06
		VIOLET: 0x05
		WHITE: 0x07
		ON: 0x07
	buttons:
		SELECT: 0x01
		RIGHT: 0x02
		DOWN: 0x04
		UP: 0x08
		LEFT: 0x10

	clear: () ->
		@writeByte LCD_CLEARDISPLAY

	home: () ->
		@writeByte LCD_RETURNHOME


	
	backlight: (color) ->
		c = ~color
		@PORTA = (@PORTA & 0x3F)  | ((c & 0x3) << 6)
		@PORTB = (@PORTB & 0xFE)  | ((c & 0x4) >> 2)
		# Has to be done as two writes because sequential operation is off.
		@sendBytes(MCP23017_GPIOA, @PORTA)
		@sendBytes(MCP23017_GPIOB, @PORTB)
		
	message: (text) ->
		lines = text.split('\n')    # Split at newline(s)
		for line, i in lines
			if i>0
				@writeByte 0xC0
			@writeByte(line, true)       # Issue substring

	buttonState: () ->
		ret= @WIRE.readBytes MCP23017_GPIOA,1
		ret= ret[0]&0x1F
		return ret


	buttonName: (val) ->
		return switch val
			when @buttons.SELECT then "SELECT"
			when @buttons.RIGHT then "RIGHT"
			when @buttons.UP then "UP"
			when @buttons.DOWN then "DOWN"
			when @buttons.LEFT then "LEFT"
			else undefined
		


	init: ()->
		@sendBytes(MCP23017_IOCON_BANK1, 0)
		@sendBytes(0, [
			0x3F, 	# IODIRA    R+G LEDs=outputs, buttons=inputs
			@DDRB, 	# IODIRB    LCD D7=input, Blue LED=output
			0x3F, 	# IPOLA     Invert polarity on button inputs
			0x0, 	# IPOLB
			0x0, 	# GPINTENA  Disable interrupt-on-change
			0x0, 	# GPINTENB
			0x0, 	# DEFVALA
			0x0, 	# DEFVALB
			0x0, 	# INTCONA
			0x0, 	# INTCONB
			0x0, 	# IOCON
			0x0, 	# IOCON
			0x3F, 	# GPPUA     Enable pull-ups on buttons
			0x0, 	# GPPUB
			0x0, 	# INTFA
			0x0, 	# INTFB
			0x0, 	# INTCAPA
			0x0, 	# INTCAPB
			@PORTA, 	# GPIOA
			@PORTB, 	# GPIOB
			@PORTA, 	# OLATA     0 on all outputs; side effect of
			@PORTB	# OLATB     turning on R+G+B backlight LEDs.
		])
		@sendBytes(MCP23017_IOCON_BANK0, 0xA0)

		displayshift = LCD_CURSORMOVE | LCD_MOVERIGHT
		displaymode = LCD_ENTRYLEFT | LCD_ENTRYSHIFTDECREMENT
		displaycontrol = LCD_DISPLAYON | LCD_CURSOROFF | LCD_BLINKOFF

		@writeByte 0x33
		@writeByte 0x32
		@writeByte 0x28
		@writeByte LCD_CLEARDISPLAY
		@writeByte(LCD_CURSORSHIFT | displayshift)
		@writeByte(LCD_ENTRYMODESET | displaymode)
		@writeByte(LCD_DISPLAYCONTROL | displaycontrol)
		@writeByte(LCD_RETURNHOME)

		@clear
		@backlight 0x0

	sendBytes: (cmd, values) ->
		reg=cmd
		if typeof values is 'number'
			data=[]
			data.push(values)
			values=data

		console.log JSON.stringify({fn: "data",data: values,address:@ADDRESS, target: cmd}) if @DEBUG
		@WIRE.writeBytes(cmd, values)

  
	sendByte: (value) ->
		console.log {fn: "byte",data: value,address:@ADDRESS} if @DEBUG
		@WIRE.writeByte(value)

	maskOut: (bitmask, value) ->
		hi = bitmask | flip[value >> 4]
		lo = bitmask | flip[value & 0x0F]
		return [ hi | 0x20, hi, lo | 0x20, lo]


	# The speed of LCD accesses is inherently limited by I2C through the
	# port expander.  A 'well behaved program' is expected to poll the
	# LCD to know that a prior instruction completed.  But the timing of
	# most instructions is a known uniform 37 mS.  The enable strobe
	# can't even be twiddled that fast through I2C, so it's a safe bet
	# with these instructions to not waste time polling (which requires
	# several I2C transfers for reconfiguring the port direction).
	# The D7 pin is set as input when a potentially time-consuming
	# instruction has been issued (e.g. screen clear), as well as on
	# startup, and polling will then occur before more commands or data
	# are issued.
	writeByte: (value, char_mode) ->
		char_mode = char_mode || false
		console.log {
			fn: "write"
			value: value
			char: char_mode
		} if @DEBUG
		# If pin D7 is in input state, poll LCD busy flag until clear.
		if @DDRB & 0x10
			lo = (@PORTB & 0x01) | 0x40
			hi = lo  | 0x20	#E=1 (strobe)
			@sendBytes(MCP23017_GPIOB, lo)
			loop
				# Strobe high (enable)
				@sendByte(hi)
				# First nybble contains busy state
				bits = @readByte()
				# Strobe low, high, low.  Second nybble (A3) is ignored.
				@sendBytes(MCP23017_GPIOB, [lo, hi, lo])
				break if (bits & 0x2) is 0 # D7=0, not busy
			@PORTB = lo
			# Polling complete, change D7 pin to output
			@DDRB &= 0xEF
			@sendBytes(MCP23017_IODIRB, @DDRB)

		bitmask = @PORTB & 0x01   # Mask out PORTB LCD control bits
		bitmask |= 0x80 if char_mode# Set data bit if not a command

		# If string iterate through multiple write ops
		if (typeof value == "string")
			last = value.length-1
			data = []
			for k in [0..last]
				# Append 4 bytes to list representing PORTB over time.
				# First the high 4 data bits with strobe (enable) set
				# and unset, then same with low 4 data bits (strobe 1/0).
				data = data.concat(@maskOut(bitmask, value[k].charCodeAt(0)))
				if (data.length >=32 || k == last)
					@sendBytes(MCP23017_GPIOB, data)
					@PORTB = data[data.length-1]
					data=[]
		else
			# Single byte
			data=@maskOut(bitmask, value)
			@sendBytes(MCP23017_GPIOB, data)
			@PORTB= data[data.length-1]



		# If a poll-worthy instruction was issued, reconfigure D7
		# pin as input to indicate need for polling on next call.
		if(!char_mode && pollables.indexOf(value)!=-1 )
			@DDRB |= 0x10;
			@sendBytes(MCP23017_IODIRB, @DDRB);
	
	readByte: () ->
		return @WIRE.readByte()


module.exports = Plate