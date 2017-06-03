document.addEventListener('turbolinks:load', function(event) {
  if (typeof ga === 'function') {
    ga('set', 'location', event.data.url);
    return ga('send', 'pageview');
  }
});
