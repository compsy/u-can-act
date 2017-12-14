function generate_range(until, reverse = false) {
  var result = $.map($(Array(until)), function(val, i) {
    return i + 1;
  })
  if (reverse) return (result.reverse());
  return (result);
}

function completedId() { return 1; }
function missedId() { return 0; }
function futureId() { return -1; }

function convert_data(data, reverse = false) {
  var result = [];
  var temp = [];
  var future_measurements = 0;
  for (var i = 0; i < data.length; i++) {
    if (data[i] !== missedId() && data[i] !== completedId()) future_measurements++;
  }

  // Create the future measurements
  if (reverse) {
    for (var i = 0; i < future_measurements; i++) {
      temp = [];
      temp.push(i);
      temp.push(0);
      temp.push(futureId());
      result.push(temp);
    }

    var future_measurement_counter = future_measurements;
    for (var i = 0; i < data.length; i++) {
      if (data[i] === missedId() || data[i] === completedId()) {
        temp = [];
        temp.push(future_measurement_counter);
        temp.push(0);
        temp.push(data[i]);
        result.push(temp);
        future_measurement_counter++;
      }
    }
  } else {
    for (var i = 0; i < data.length; i++) {
      temp = [];
      temp.push(i);
      temp.push(0);
      temp.push(data[i]);
      result.push(temp);
      future_measurement_counter++;
    }
  }

  return result;
}


function process_data(data, location, reverse) {
  var result = convert_data(data, reverse);
  var range = generate_range(data.length, reverse);
  plot_heatmap(result, range, location);
}

function plot_heatmap(data, range, location) {
  $(location).highcharts({
    chart: {
      type: 'heatmap',
      backgroundColor: null,
      plotBorderWidth: null,
      height: 68
    },
    xAxis: {
      categories: range,
      tickInterval: 5
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
    if ($.isEmptyObject(data)) { return false; }
    var result = data.protocol_completion.map(function(entry) {
      if (entry.future) return futureId();
      if (entry.completed) return completedId();
      return missedId();
    })
    process_data(result, container_id);
  });
}
