var honkit_link = $('a[class=gitbook-link]');

var text = honkit_link.text();
honkit_link.parent().html(`<span style="align: center;">${text}</span>`);

$("li.chapter > a").click(function() {
  $(".book-body").css("left", "300px !important");
});

