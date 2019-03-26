/*
Alternative paint apps:
- https://pusher.com/tutorials/live-paint-react
- https://konvajs.github.io/docs/sandbox/Free_Drawing.html
 */

// spray alternative


function getRandomFloat(min, max) {
  return Math.random() * (max - min) + min;
}

const COLOURS = ['#e57373', '#64b5f6', '#AC92EB', '#4FC1E8', '#A0D568', '#FFCE54', '#ED5564'];
const LOCK_TEXT = "<i class=\"material-icons left\">lock_open</i>Vastleggen";
const UNLOCK_TEXT = "<i class=\"material-icons left\">lock</i>Aanpassen";


$(function() {

  let mydrawing = Sketch.create({
    container: document.getElementById('sketch-container'),
    fullscreen: false,
    width: 240,
    height: 536,
    radius: 15,
    density: 40,
    currentpoints: [],
    autoclear: false,
    locked: false,
    drawing: false,
    timeout: null,
    clientX: null,
    clientY: null,
    retina: 'auto',

    setup: function() {
      // console.log('setup');
    },

    setLineStyleAndColor: function(color) {
      this.lineCap = 'round';
      this.lineJoin = 'round';
      this.fillStyle = this.strokeStyle = color;
      this.lineWidth = this.radius;
    },

    clearDrawing: function() {
      this.currentpoints = [];
      this.drawing = false;
      $('#log').empty();
      this.clear();
    },

    lockDrawing: function() {
      this.stop();
      this.locked = true;
      this.drawing = false;
    },

    unlockDrawing: function() {
      this.start();
      this.locked = false;
    },

    drawCurrentPoints: function() {
      this.setLineStyleAndColor(COLOURS[0 % COLOURS.length]);
      for (let [x, y] of this.currentpoints)
        this.drawPoint(x, y);
    },

    update: function() {

    },

    // Event handlers

    keydown: function() {
      if (this.keys.C) {
        this.clearDrawing();
      }
    },

    logPoint: function(x, y) {
      // TODO: FIX THAT WE STORE AND RESTORE THE COORDS IN SCALED FORM
      this.currentpoints.push([x, y]);
      document.getElementById('log').innerHTML += `(${(x / this.width).toFixed(2)},
                                                     ${(y / this.height).toFixed
      (2)})<br>`;
      const objDiv = document.getElementById("log");
      objDiv.scrollTop = objDiv.scrollHeight;
    },

    touchend: function() {
      if (this.locked) return;
      this.drawing = false;
      this.clientX = null;
      this.clientY = null;
      clearTimeout(this.timeout);
    },

    mouseout: function() {

    },

    drawPoint: function(x, y) {
      for (let i = this.density; i--;) {
        const angle = getRandomFloat(0, Math.PI * 2);
        const radius = getRandomFloat(0, this.radius);
        this.fillRect(
          x + radius * Math.cos(angle),
          y + radius * Math.sin(angle),
          1, 1);
      }
    },

    touchstart: function() {
      if (this.locked) return;
      this.drawing = true;
      this.setLineStyleAndColor(COLOURS[0 % COLOURS.length]);
      const touch = this.touches[0]; // only support drawing with one finger
      this.clientX = touch.x;
      this.clientY = touch.y;

      let self = this;
      this.timeout = setTimeout(function draw() {
        if (self.clientX !== null && self.clientY !== null) {
          self.logPoint(self.clientX, self.clientY);
          self.drawPoint(self.clientX, self.clientY);
        }
        if (!self.timeout) return;
        self.timeout = setTimeout(draw, 25);
      }, 25);
    },

    // Mouse & touch events are merged, so handling touch events by default
    // and powering sketches using the touches array is recommended for easy
    // scalability. If you only need to handle the mouse / desktop browsers,
    // use the 0th touch element and you get wider device support for free.
    touchmove: function() {
      if (this.locked) return;
      if (!this.drawing) return;
      const touch = this.touches[0]; // only support drawing with one finger
      this.clientX = touch.x;
      this.clientY = touch.y;
    }
  });

  $('#clear').click(function(e) {
    e.preventDefault();
    mydrawing.clearDrawing();
  });
  $('#ok').click(function(e) {
    e.preventDefault();
    if ($(this).html() === LOCK_TEXT) {
      $(this).html(UNLOCK_TEXT);
      $('#clear').prop("disabled", true);
      mydrawing.lockDrawing();
    } else {
      $(this).html(LOCK_TEXT);
      $('#clear').prop("disabled", false);
      mydrawing.unlockDrawing();
    }
  }).html(LOCK_TEXT);
  $(window).resize(function() {
    mydrawing.clear();
    mydrawing.drawCurrentPoints();
  });






  // second drawing

  let mydrawing1 = Sketch.create({
    container: document.getElementById('sketch-container1'),
    fullscreen: false,
    width: 240,
    height: 536,
    radius: 15,
    density: 40,
    currentpoints: [],
    autoclear: false,
    locked: false,
    drawing: false,
    timeout: null,
    clientX: null,
    clientY: null,
    retina: 'auto',

    setup: function() {
      // console.log('setup');
    },

    setLineStyleAndColor: function(color) {
      this.lineCap = 'round';
      this.lineJoin = 'round';
      this.fillStyle = this.strokeStyle = color;
      this.lineWidth = this.radius;
    },

    clearDrawing: function() {
      this.currentpoints = [];
      this.drawing = false;
      $('#log1').empty();
      this.clear();
    },

    lockDrawing: function() {
      this.stop();
      this.locked = true;
      this.drawing = false;
    },

    unlockDrawing: function() {
      this.start();
      this.locked = false;
    },

    drawCurrentPoints: function() {
      this.setLineStyleAndColor(COLOURS[1 % COLOURS.length]);
      for (let [x, y] of this.currentpoints)
        this.drawPoint(x, y);
    },

    update: function() {

    },

    // Event handlers

    keydown: function() {
      if (this.keys.C) {
        this.clearDrawing();
      }
    },

    logPoint: function(x, y) {
      // TODO: FIX THAT WE STORE AND RESTORE THE COORDS IN SCALED FORM
      this.currentpoints.push([x, y]);
      document.getElementById('log').innerHTML += `(${(x / this.width).toFixed(2)},
                                                     ${(y / this.height).toFixed
      (2)})<br>`;
      const objDiv = document.getElementById("log1");
      objDiv.scrollTop = objDiv.scrollHeight;
    },

    touchend: function() {
      if (this.locked) return;
      this.drawing = false;
      this.clientX = null;
      this.clientY = null;
      clearTimeout(this.timeout);
    },

    mouseout: function() {

    },

    drawPoint: function(x, y) {
      for (let i = this.density; i--;) {
        const angle = getRandomFloat(0, Math.PI * 2);
        const radius = getRandomFloat(0, this.radius);
        this.fillRect(
          x + radius * Math.cos(angle),
          y + radius * Math.sin(angle),
          1, 1);
      }
    },

    touchstart: function() {
      if (this.locked) return;
      this.drawing = true;
      this.setLineStyleAndColor(COLOURS[1 % COLOURS.length]);
      const touch = this.touches[0]; // only support drawing with one finger
      this.clientX = touch.x;
      this.clientY = touch.y;

      let self = this;
      this.timeout = setTimeout(function draw() {
        if (self.clientX !== null && self.clientY !== null) {
          self.logPoint(self.clientX, self.clientY);
          self.drawPoint(self.clientX, self.clientY);
        }
        if (!self.timeout) return;
        self.timeout = setTimeout(draw, 25);
      }, 25);
    },

    // Mouse & touch events are merged, so handling touch events by default
    // and powering sketches using the touches array is recommended for easy
    // scalability. If you only need to handle the mouse / desktop browsers,
    // use the 0th touch element and you get wider device support for free.
    touchmove: function() {
      if (this.locked) return;
      if (!this.drawing) return;
      const touch = this.touches[0]; // only support drawing with one finger
      this.clientX = touch.x;
      this.clientY = touch.y;
    }
  });

  $('#clear1').click(function(e) {
    e.preventDefault();
    mydrawing1.clearDrawing();
  });
  $('#ok1').click(function(e) {
    e.preventDefault();
    if ($(this).html() === LOCK_TEXT) {
      $(this).html(UNLOCK_TEXT);
      $('#clear1').prop("disabled", true);
      mydrawing1.lockDrawing();
    } else {
      $(this).html(LOCK_TEXT);
      $('#clear1').prop("disabled", false);
      mydrawing1.unlockDrawing();
    }
  }).html(LOCK_TEXT);
  $(window).resize(function() {
    mydrawing1.clear();
    mydrawing1.drawCurrentPoints();
  });
});
