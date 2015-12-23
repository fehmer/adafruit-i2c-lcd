# Adafruit I2C LCD Plate

Node.js implementation for the Adafruit RGB 16x2 LCD+Keypad Kit for Raspberry Pi 
http://www.adafruit.com/products/1110

**Note!**

Use version 0.0.3 for node js 0.11 and under and version 0.1.x for node js 0.12!


## Usage

1. read the [i2c documentation](https://www.npmjs.org/package/i2c) how to setup your raspberry pi.
2. add dependency using ```npm install adafruit-i2c-lcd --save```
3. copy the example (coffee or js) and run them using ```coffee``` or ```node```. Maybe you have to run them as root.

### coffeescript

```coffeescript
LCDPLATE=require('adafruit-i2c-lcd').plate
lcd=new LCDPLATE  '/dev/i2c-1', 0x20

lcd.backlight lcd.colors.RED
lcd.message 'Hello World!'
```

### javascript

```javascript
var LCDPLATE, lcd;
LCDPLATE = require('adafruit-i2c-lcd').plate;
lcd = new LCDPLATE('/dev/i2c-1', 0x20);

lcd.backlight(lcd.colors.RED);
lcd.message('Hello World!');

```

API
====

  - [LCDPLATE(device:String,address:Number,[pollInterval:Number])](#lcdplatedevicestringaddressnumberpollintervalnumber)
  - [LCDPLATE.clear()](#lcdplateclear)
  - [LCDPLATE.close()](#lcdplateclose)
  - [LCDPLATE.backlight(color:Number)](#lcdplatebacklightcolornumber)
  - [LCDPLATE.message(text:String)](#lcdplatemessagetextstring)
  - [LCDPLATE.buttonState():Number](#lcdplatebuttonstatenumber)
  - [LCDPLATE.buttonName(val:Number):String](#lcdplatebuttonnamevalnumberstring)

## LCDPLATE(device:String,address:Number,[pollInterval:Number])

Setting up a new LCDPLATE. 

- device: Device name, e.g. '/dev/i2c-1'
- address: Address of the i2c panel, e.g. 0x20
- pollInterval: optional. Set the poll interval for the buttons to x ms. Use pollInterval=-1 to disable polling. (Buttons will not work)

## LCDPLATE.clear()

Clear the LCD, remove all text.

## LCDPLATE.close()

Close the LCD plate. Use this to stop the polling.

## LCDPLATE.backlight(color:Number)

Set the backlight of the LCD to the given color. You can use predefined colors from the LCDPLATE class: 

LCDPLATE.colors = [OFF, RED, GREEN, BLUE, YELLOW, TEAL, VIOLET, WHITE, ON]


## LCDPLATE.message(text:String)

Display the text on the LCD. Use \n as line feed. Only the first two lines will be sent to the display.

## LCDPLATE.buttonState():Number

Returns the pressed buttons as a number. Use bitmasks to mask out the state of the desired button. See LCDPLATE.buttons for button values.

## LCDPLATE.buttonName(val:Number):String

Returns the name, e.g. 'SELECT' to a button number. See LCDPLATE.buttons for button values.

# Events

## button_change

Fires if a button is pressed or released. 

Parameters:   
    
* button: the button, See LCDPLATE.buttons for button values.

## Example
```coffeescript
lcd.on 'button_change', (button) ->
    lcd.clear()
	lcd.message 'Button changed:\n'+lcd.buttonName button
```

## button_up

Fires if a button is released. 

Parameters:   
    
* button: the button, See LCDPLATE.buttons for button values.


## button_down

Fires if a button is pressed.

Parameters:   
    
* button: the button, See LCDPLATE.buttons for button values.

## Compatibility

This library is compatible with the Sainsmart 1602 I2C (SKU: 20-011-221)
with some notable exceptions.  This clone has a blue backlight and an
RGB LED on-board.

* The [LCDPLATE.backlight()](#lcdplatebacklightcolornumber) function
changes the RGB LED rather than the backlight.
* The backlight on the LCD is connected to GPA5, which is the sixth (6th)
bit of port A.  It can be set on or off directly in your client code.

```javascript
    lcd.sendBytes(0, 0x00); // Sainsmart 1602 I2C backlight on
    lcd.sendBytes(0, 0x20); // Sainsmart 1602 I2C backlight off
```

## Licence
BSD

Based on the [Adafruit's Raspberry-Pi Python Code Library](https://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code.git)

>  Here is a growing collection of libraries and example python scripts
>  for controlling a variety of Adafruit electronics with a Raspberry Pi
  
>  In progress!
>
>  Adafruit invests time and resources providing this open source code,
>  please support Adafruit and open-source hardware by purchasing
>  products from Adafruit!
>
>  Written by Limor Fried, Kevin Townsend and Mikey Sklar for Adafruit Industries.
>  BSD license, all text above must be included in any redistribution
>
>  To download, we suggest logging into your Pi with Internet accessibility and typing:
>  git clone https://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code.git
