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
    $a = $h1.find('a');
    $p = $element.find('p');

    // 1.5 is an aribitrary value that only makes sense for this font
    maxCharacterWidth = ($element.width()/$a.html().length)*1.5;

    $h1.css({
      fontSize: Math.min($element.height()/4.0, maxCharacterWidth),
      marginTop: $element.height()/3.0
    });

    $p.css({
      fontSize: parseInt($h1.css('fontSize'),10)/4.0
    });
  });
};
