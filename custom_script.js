require(['gitbook', 'jQuery'], function(gitbook, $) {
  var honkit_link = $('a[class=gitbook-link]');

  var text = honkit_link.text();
  honkit_link.parent().html(`<span style="align: center;">${text}</span>`);

  //
  gitbook.events.bind('page.change', function() {

    setTimeout(() => {
      var el = $('div.book-body');
      console.log("Page changed");
      el.attr('style', 'left: 300px; position: absolute;');
      console.log(el.attr('style'));
    }, 500);
  });
});
