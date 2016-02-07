var LCDPLATE, lcd;
LCDPLATE = require('adafruit-i2c-lcd').plate;
lcd = new LCDPLATE(1, 0x20);
var index = 0;

# create some custom characters
lcd.createChar(1, [2, 3, 2, 2, 14, 30, 12, 0])
lcd.createChar(2, [0, 1, 3, 22, 28, 8, 0, 0])
lcd.createChar(3, [0, 14, 21, 23, 17, 14, 0, 0])
lcd.createChar(4, [31, 17, 10, 4, 10, 17, 31, 0])
lcd.createChar(5, [8, 12, 10, 9, 10, 12, 8, 0])
lcd.createChar(6, [2, 6, 10, 18, 10, 6, 2, 0])
lcd.createChar(7, [31, 17, 21, 21, 21, 21, 17, 31])

//demo content
var demo = [{
    color: lcd.colors.RED,
    message: 'test backlight\n color: RED \x01'
  }, {
    color: lcd.colors.GREEN,
    message: 'test backlight\n color: GREEN \x02'
  }, {
    color: lcd.colors.BLUE,
    message: 'test backlight\n color: BLUE \x03'
  }, {
    color: lcd.colors.YELLOW,
    message: 'test backlight\n color: YELLOW \x04'
  }, {
    color: lcd.colors.TEAL,
    message: 'test backlight\n color: TEAL \x05'
  }, {
    color: lcd.colors.VIOLET,
    message: 'test backlight\n color: VIOLET \x06'
  }, {
    color: lcd.colors.WHITE,
    message: 'test backlight\n color: WHITE  \x07'
  }, {
    color: lcd.colors.WHITE,
    message: 'now try pressing\n some buttons!'
  }

]

// show button state on lcd and console
function displayButton(state, button) {
  lcd.clear();
  lcd.message('Button: ' + lcd.buttonName(button) + '\nState: ' + state);
  console.log(state, lcd.buttonName(button));
}

//show hello world in red
lcd.backlight(lcd.colors.RED);
lcd.message('Hello World!\nLoading demo...');

//start demo, loop over the demo content.
var demoInterval = setInterval(function() {
  if (index < 8) {
    //show demo content
    lcd.clear();
    lcd.backlight(demo[index].color);
    lcd.message(demo[index].message);
  } else {
    //end of demo
    clearInterval(demoInterval);

    //register events to show button press/release
    lcd.on('button_change', function(button) {
      console.log('button_change', lcd.buttonName(button));
    });

    lcd.on('button_down', function(button) {
      displayButton('pressed', button);
    });

    lcd.on('button_up', function(button) {
      displayButton('released', button);
    });
  }
  index++;
}, 1000);