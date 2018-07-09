function completedId() {
  return 1;
}

function missedId() {
  return 0;
}

function futureId() {
  return -1;
}

function generate_range(until) {
  var result = $.map($(Array(until)), function(val, i) {
    return i + 1;
  })
  return (result);
}

function convert_data(data) {
  var result = [];
  var temp, entry;
  var future_measurements = 0;

  for (var i = 0; i < data.length; i++) {
    entry = data[i];
    if (entry.value !== missedId() && entry.value !== completedId()) future_measurements++;
  }

  // Create the measurements
  var first = false;
  for (var i = 0; i < data.length; i++) {
    entry = data[i];
    temp = build_entry(i, entry.value, !first && entry.future_or_current)
    result.push(temp);

    if (entry.future_or_current) first = true;
  }

  return result;
}

function build_entry(x, value, is_current_week) {
  var temp = {
    "x": x,
    "y": 0,
    "value": value,
    "borderWidth": 1,
    "borderColor": "white"
  };

  if (is_current_week) temp["borderColor"] = "#243a76"; 
  return temp;
}

function process_data(data, location) {
  var result = convert_data(data);
  var range = generate_range(data.length);
  plot_heatmap(result, range, location);
}

function plot_heatmap(data, range, location) {
  (function(H) {
    H.wrap(H.seriesTypes.heatmap.prototype, 'translate', function(proceed) {
      var each = H.each,
        series = this,
        options = series.options,
        xAxis = series.xAxis,
        yAxis = series.yAxis,
        between = function(x, a, b) {
          return Math.min(Math.max(a, x), b);
        },
        pixelSpacing = options.pixelSpacing || [0, 0, 0, 0];

      series.generatePoints();

      each(series.points, function(point) {
        var xPad = (options.colsize || 1) / 2,
          yPad = (options.rowsize || 1) / 2,
          x1 = between(Math.round(xAxis.len - xAxis.translate(point.x - xPad, 0, 1, 0, 1) + pixelSpacing[3]), 0, xAxis.len),
          x2 = between(Math.round(xAxis.len - xAxis.translate(point.x + xPad, 0, 1, 0, 1) - pixelSpacing[1]), 0, xAxis.len),
          y1 = between(Math.round(yAxis.translate(point.y - yPad, 0, 1, 0, 1) - pixelSpacing[2]), 0, yAxis.len),
          y2 = between(Math.round(yAxis.translate(point.y + yPad, 0, 1, 0, 1) + pixelSpacing[0]), 0, yAxis.len);

        // Set plotX and plotY for use in K-D-Tree and more
        point.plotX = point.clientX = (x1 + x2) / 2;
        point.plotY = (y1 + y2) / 2;

        point.shapeType = 'rect';
        point.shapeArgs = {
          x: Math.min(x1, x2),
          y: Math.min(y1, y2),
          width: Math.abs(x2 - x1),
          height: Math.abs(y2 - y1)
        };
      });

      series.translateColors();

      // Make sure colors are updated on colorAxis update (#2893)
      if (this.chart.hasRendered) {
        each(series.points, function(point) {
          point.shapeArgs.fill = point.options.color || point.color; // #3311
        });
      }
    });
  }(Highcharts));
  $(location).highcharts({
    chart: {
      type: 'heatmap',
      backgroundColor: null,
      plotBorderWidth: null,
      height: 68
    },
    xAxis: {
      categories: range,
      tickInterval: 2
    },
    yAxis: {
      categories: ["Person"],
      labels: {
        enabled: false
      },
      title: null
    },
    colorAxis: {
      stops: [
        [0, '#e0e0e0'],
        [0.5, '#d9534f'],
        [1, '#009a74']
      ],
      min: -1,
      max: 1,
    },
    tooltip: {
      backgroundColor: '#ffffff',
      borderWidth: 0,
      distance: 12,
      shadow: false,
      useHTML: true,
      style: {
        padding: 0,
        color: 'black'
      },
      formatter: function() {
        var text = this.point.value === missedId() ? 'Missende meting' : this.point.value === completedId() ? 'Succesvolle meting' : 'Toekomstige meting';
        return text;
      }
    },
    series: [{
      pixelSpacing: [1, 1, 1, 1],
      borderWidth: 0,
      data: data
    }],
    // Disable some settings
    exporting: {
      enabled: false
    },
    credits: {
      enabled: false
    },
    title: {
      text: ''
    },
    legend: {
      enabled: false
    }
  });
}

function start_overview_generation(id) {
  var container_id = "#container_" + id;
  var ajax_promise = $.getJSON('api/v1/protocol_subscriptions/' + id);

  ajax_promise.done(function(data) {
    if ($.isEmptyObject(data)) return false;

    var result = data.protocol_completion.map(function(entry) {
      var value = missedId();
      if (entry.future) {
        value = futureId();
      } else if (entry.completed) {
        value = completedId();
      }
      if (entry.periodical) {
        return {
          "future_or_current": entry.future_or_current,
          "value": value
        }
      }
      return undefined;
    })
    result = result.filter(function(n) {
      return n != undefined
    });
    process_data(result, container_id);
  });
}
