LCDPLATE=require('../lib/index').plate
lcd=new LCDPLATE  '/dev/i2c-1', 0x20
console.log "end"
setTimeout ()->
	console.log "red"
	lcd.backlight lcd.color.RED
, 10

i=0

circle = () ->
	for color in Object.keys(lcd.color)
		do (color)->
			i++
			setTimeout ()->
				console.log i, color, lcd.color[color]
				lcd.backlight lcd.color[color]
			, i* 2000
	console.log "done"


setTimeout circle, 2000


