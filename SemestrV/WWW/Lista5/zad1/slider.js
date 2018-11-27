$(function () {

  var slideCount = $('#slider ul li').length;
  var slideWidth = $('#slider ul li').width();
  var slideHeight = $('#slider ul li').height();
  var sliderUlWidth = slideCount * slideWidth;
  var animationSpeed = 3000;

  var interval;

  $('#slider').css({
    width: slideWidth,
    height: slideHeight
  });

  $('#slider ul').css({
    width: sliderUlWidth,
    marginLeft: -slideWidth
  });

  $('#slider ul li:last-child').prependTo('#slider ul');

  $('input[type="range"]').rangeslider({
    polyfill: false,
    onInit: function () {
      this.output = $('<div class="range-output" />').insertAfter(this.$range).html(this.$element.val());
    },
    onSlide: function (position, value) {
      this.output.html(value + 's');
      animationSpeed = value * 1000;
      clearInterval(interval);
      interval = setInterval(function () {
        startSlider();
      }, animationSpeed);
    }
  });

  function startSlider() {
    $('#slider ul').animate({
      left: -slideWidth
    }, 200, function () {
      $('#slider ul li:first-child').appendTo('#slider ul');
      $('#slider ul').css('left', '');
    });
  };

  $('#slider').mouseover(function () {
    clearInterval(interval);
  });

  $('#slider').mouseleave(function () {
    interval = setInterval(function () {
      startSlider();
    }, animationSpeed);
  });

  interval = setInterval(function () {
    startSlider();
  }, animationSpeed);

});