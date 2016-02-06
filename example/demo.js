var LCDPLATE, lcd;
LCDPLATE = require('adafruit-i2c-lcd').plate;
lcd = new LCDPLATE(1, 0x20);
var index = 0;

//demo content
var demo = [{
    color: lcd.colors.RED,
    message: 'test backlight\n color: RED'
  }, {
    color: lcd.colors.GREEN,
    message: 'test backlight\n color: GREEN'
  }, {
    color: lcd.colors.BLUE,
    message: 'test backlight\n color: BLUE'
  }, {
    color: lcd.colors.YELLOW,
    message: 'test backlight\n color: YELLOW'
  }, {
    color: lcd.colors.TEAL,
    message: 'test backlight\n color: TEAL'
  }, {
    color: lcd.colors.VIOLET,
    message: 'test backlight\n color: VIOLET'
  }, {
    color: lcd.colors.WHITE,
    message: 'test backlight\n color: WHITE'
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