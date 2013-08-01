LCDPLATE=require('../lib/index').plate
lcd=new LCDPLATE  '/dev/i2c-1', 0x20

circle = () ->
	console.log 'circle'
	i=0
	for color in Object.keys(lcd.colors)
		do (color)->
			i++
			setTimeout ()->
				lcd.clear()
				lcd.message "Color:\n "+ color
				lcd.backlight lcd.colors[color]
			, i* 750
	console.log "done"

disco = () ->
	console.log 'disco'
	lcd.clear()
	lcd.message ' * * * DISCO * * * \n* * * * * * * * * * * * * * * * '
	for i in [0..1000]
		setTimeout () ->
			color = Math.floor((Math.random()*6)+1)
			color=Object.keys(lcd.colors)[color]
			lcd.backlight lcd.colors[color]
		, i*50




lcd.backlight lcd.colors.RED
console.log "message"
lcd.message "Hello."


setTimeout circle, 2000
setTimeout disco, 10000



lcd.on 'button_up', (button) ->
	lcd.clear()
	lcd.message 'Button up:\n'+lcd.buttonName button

lcd.on 'button_down', (button) ->
	lcd.clear()
	lcd.message 'Button down:\n'+lcd.buttonName button


