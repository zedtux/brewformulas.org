function formulaSparlineBuilder() {
  var rangeMax = null;

  if ($('.sparkline').length <= 100) {
    $('.sparkline').each(function() {
      var value = parseFloat($(this).data('top-sparkline'));
      rangeMax = (value > rangeMax) ? value : rangeMax;
    });

    var options = {
      type: 'line',
      width: '100%',
      spotColor: false,
      minSpotColor: false,
      maxSpotColor: false,
      highlightLineColor: null,
      defaultPixelsPerValue: 5,
      lineColor: 333333,
      chartRangeMin: 0,
      chartRangeMax: rangeMax
    };

    $.each($('.sparkline'), function(index, element) {
      $(element).sparkline($(element).data('sparkline'), options);
    });
  }
}

$(document).on('turbolinks:load', function() {
  if ($('.trendings.index').length > 0 || $('.news.index').length > 0 ||
      $('.formulas.index').length > 0) {
    formulaSparlineBuilder();
  }
});
