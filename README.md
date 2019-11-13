# Adafruit I2C LCD Plate

Node.js implementation for the Adafruit RGB 16x2 LCD+Keypad Kit for Raspberry Pi
http://www.adafruit.com/products/1110

**Note:** This readme is for the current version 1.x.x/2.x.x. If you are using older versions please read the [version 0.0.x readme](https://github.com/fehmer/adafruit-i2c-lcd/tree/0.0.x) or [version 0.1.x readme](https://github.com/fehmer/adafruit-i2c-lcd/tree/0.1.x).

**Note:** Since version 1.0.0 this module is based on [i2c-bus](https://www.npmjs.com/package/i2c-bus). For compatibility with your node.js version read the i2c-bus documentation. Older versions of this module were based on [i2c](https://www.npmjs.com/package/i2c). adafruit-i2c-lcd version 0.1.x only works with node.js 0.12.x and adafruit-i2c-lcd version 0.0.x only works with node.js 0.10.x.

**Note:** Version 2.0.0 and greater drops support for node v4, v5, and v7 as well as npm < v4 (update npm by running the command ```npm i npm -g```)

**Note:** This module is compatible with  Sainsmart 1602 I2C, see [Compatibility](#compatibility)

## Usage

1. read the [i2c-bus documentation](https://github.com/fivdi/i2c-bus/blob/master/doc/raspberry-pi-i2c.md) how to setup your raspberry pi.
2. add dependency using ```npm install adafruit-i2c-lcd --save```
3. Copy and run one of the examples from the examples directory. Maybe you have to run them as root.

### simple example

```javascript
var LCDPLATE, lcd;
LCDPLATE = require('adafruit-i2c-lcd').plate;
lcd = new LCDPLATE(1, 0x20);

lcd.backlight(lcd.colors.RED);
lcd.message('Hello World!');

lcd.on('button_change', function(button) {
  lcd.clear();
  lcd.message('Button changed:\n' + lcd.buttonName(button));
});
```


## API

  - [LCDPLATE(device:String,address:Number,[pollInterval:Number])](#lcdplatedevicestringaddressnumberpollintervalnumber)
  - [LCDPLATE.clear()](#lcdplateclear)
  - [LCDPLATE.close()](#lcdplateclose)
  - [LCDPLATE.backlight(color:Number)](#lcdplatebacklightcolornumber)
  - [LCDPLATE.message(text:String,[clear:boolean])](#lcdplatemessagetextstring-booleanclear)
  - [LCDPLATE.createChar(index:Number, pattern:byte[])](#lcdplatecreatecharindexnumber-patternbyte)
  - [LCDPLATE.buttonState():Number](#lcdplatebuttonstatenumber)
  - [LCDPLATE.buttonName(val:Number):String](#lcdplatebuttonnamevalnumberstring)

### LCDPLATE(device:String,address:Number,[pollInterval:Number])

Setting up a new LCDPLATE.

- device: Device name, e.g. '/dev/i2c-1'
- address: Address of the i2c panel, e.g. 0x20
- pollInterval: optional. Set the poll interval for the buttons to x ms. Use pollInterval=-1 to disable polling. (Buttons will not work)

### LCDPLATE.clear()

Clear the LCD, remove all text.

### LCDPLATE.close()

Close the LCD plate. Use this to stop the polling.

### LCDPLATE.backlight(color:Number)

Set the backlight of the LCD to the given color. You can use predefined colors from the LCDPLATE class:

LCDPLATE.colors = [OFF, RED, GREEN, BLUE, YELLOW, TEAL, VIOLET, WHITE, ON]


### LCDPLATE.message(text:String, [boolean:clear])

Add the text on the LCD. Use \n as line feed. Only the first two lines will be sent to the display.
If parameter clear is given and true only the text is shown, previous content on the lcd will be cleared.

### LCDPLATE.createChar(index:Number, pattern:byte[])

Defines custom characters. Index must be between 0 and 7. Pattern is the pattern of your character, must contain exactly 8 bytes.
E.g. you can easyly design your custom character at http://www.quinapalus.com/hd44780udg.html to show your custom character use eg. lcd.message('\x01').

Example:
```javascript
lcd.createChar(1, [0,0,10,31,31,14,4,0]);
lcd.createChar(2, [0,4,10,17,17,10,4,0]);

lcd.clear();
lcd.backlight(lcd.colors.RED);
lcd.message('I\x01 n\x02de.js', true);
```


### LCDPLATE.buttonState():Number

Returns the pressed buttons as a number. Use bitmasks to mask out the state of the desired button. See LCDPLATE.buttons for button values.

### LCDPLATE.buttonName(val:Number):String

Returns the name, e.g. 'SELECT' to a button number. See LCDPLATE.buttons for button values.

## Events

### button_change

Fires if a button is pressed or released.

Parameters:   

* button: the button, See LCDPLATE.buttons for button values.

### Example
```javascript
lcd.on('button_change', function(button) {
  lcd.clear();
  lcd.message('Button changed:\n' + lcd.buttonName(button));
});
```

### button_up

Fires if a button is released.

Parameters:   

* button: the button, See LCDPLATE.buttons for button values.


### button_down

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
    lcd.sendBytes(0, 0x1F); // Sainsmart 1602 I2C backlight on
    lcd.sendBytes(0, 0x3F); // Sainsmart 1602 I2C backlight off
```


## Licence

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
