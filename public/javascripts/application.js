$(function() {
  setFontSizes();
});

$(window).resize(function() {
  setFontSizes();
});

var setFontSizes = function() {
  $.each($('#projects-board .project'), function(index, element) {
    $element = $(element);

    $h1 = $element.find('h1');
    $h2 = $element.find('h2');
    $a = $h1.find('a');
    $p = $element.find('p');

    // 1.5 is an aribitrary value that only makes sense for this font
    maxCharacterWidth = ($element.width()/$a.html().length)*1.5;

    $h1.css({
      fontSize: Math.min($element.height()/6.0, maxCharacterWidth),
      marginTop: $element.height()/10.0
    });
    $h2.css({
      fontSize: Math.min($element.height()/9.0, maxCharacterWidth),
      marginTop: $element.height()/20.0,
      marginBottom: $element.height()/20.0
    });
    $p.css({
      fontSize: parseInt($h1.css('fontSize'),10)/1.5
    });
  });
};
