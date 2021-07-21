$(function() {
    $('.acdn-btn').click(function() {
        var $acdn = $(this).next();
        if($acdn.hasClass('open')) {
          $acdn.removeClass('open');
          $acdn.slideUp();
        } else {
          $(this).next('div').removeClass('hide'); 
          $(this).next('div').addClass('open');
          $(this).next('div').slideDown();
        }
  });
});
