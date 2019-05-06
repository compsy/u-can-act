// Drawing logic

function getRandomFloat(min, max) {
  return Math.random() * (max - min) + min;
}

const LOCK_TEXT = "<i class=\"material-icons left\">lock_open</i>Vastleggen";
const UNLOCK_TEXT = "<i class=\"material-icons left\">lock</i>Aanpassen";

function readDataProperty(elem, property) {
  // abstracted in its own version so we can more easily factor out jQuery later
  return $(elem).data(property);
}

function initializeDrawing(elem, idx) {
  const domelem = $(elem)[0];
  const width = readDataProperty(elem, 'width');
  const height = readDataProperty(elem, 'height');
  const image = readDataProperty(elem, 'image');
  const color = readDataProperty(elem, 'color');
  const radius = readDataProperty(elem, 'radius');
  const density = readDataProperty(elem, 'density');

  const logelem = $(elem).closest('.drawing').find('.drawing-log')[0];
  const okelem = $(elem).closest('.drawing').find('.drawing-ok')[0];
  const clearelem = $(elem).closest('.drawing').find('.drawing-clear')[0];

  $(elem).css('background-image', 'url("' + image + '")');
  $(elem).css('width', width + 'px');
  $(elem).css('height', height + 'px');
  $(logelem).css('height', height + 'px');

  let mydrawing = Sketch.create({
    container: domelem,
    fullscreen: false,
    width: width,
    height: height,
    radius: radius,
    density: density,
    currentpoints: [],
    autoclear: false,
    locked: false,
    drawing: false,
    timeout: null,
    clientX: null,
    clientY: null,
    retina: 'auto',
    color: color,
    logelem: logelem,
    okelem: okelem,
    clearelem: clearelem,

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
      $(this.logelem).empty();
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
      this.setLineStyleAndColor(this.color);
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
      this.logelem.innerHTML += `(${(x / this.width).toFixed(2)},
                                  ${(y / this.height).toFixed(2)})<br>`;
      const objDiv = this.logelem;
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
      this.setLineStyleAndColor(this.color);
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

  $(clearelem).click(function(e) {
    e.preventDefault();
    mydrawing.clearDrawing();
  });
  $(okelem).click(function(e) {
    e.preventDefault();
    if ($(this).html() === LOCK_TEXT) {
      $(this).html(UNLOCK_TEXT);
      $(clearelem).prop("disabled", true);
      mydrawing.lockDrawing();
      $(this).blur();
    } else {
      $(this).html(LOCK_TEXT);
      $(clearelem).prop("disabled", false);
      mydrawing.unlockDrawing();
      $(this).blur();
    }
  }).html(LOCK_TEXT);
  $(window).resize(function() {
    mydrawing.clear();
    mydrawing.drawCurrentPoints();
  });
}

$(function() {
  $('.drawing-container').each(function(idx) {
    initializeDrawing(this, idx);
  });
});
