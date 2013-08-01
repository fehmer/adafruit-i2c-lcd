LCDPLATE=require('../lib/index').plate
lcd=new LCDPLATE  '/dev/i2c-1', 0x20
lcd.backlight lcd.color.RED
console.log "message"
lcd.message "Hello."


for i in  [0..5]
	setTimeout () ->
		lcd.message "."
	,i*500



circle = () ->
	i=0
	for color in Object.keys(lcd.color)
		do (color)->
			i++
			setTimeout ()->
				lcd.clear()
				lcd.message "Color:\n "+ color
				lcd.backlight lcd.color[color]
			, i* 750
	console.log "done"

disco = () ->
	lcd.clear()
	lcd.message ' * * * DISCO * * * \n* * * * * * * * * * * * * * * * '
	for i in [0..1000]
		setTimeout () ->
			color = Math.floor((Math.random()*6)+1)
			color=Object.keys(lcd.color)[color]
			lcd.backlight lcd.color[color]
		, i*50

setTimeout circle, 2000
setTimeout disco, 10000


