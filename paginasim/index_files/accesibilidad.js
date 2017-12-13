jQuery(function($){
  $('.accesibilidad a').each(
      function(i){
        $(this).click(
          function(e){
            var a=$(this);
            $('#block-system-main p,#block-system-main ul li,#block-system-main ol li,#block-system-main strong').each(
              function(i){
                $(this).removeClass('accesibilidad-small').removeClass('accesibilidad-medium').removeClass('accesibilidad-large');
                $('.accesibilidad a').each(
                  function(i){
                    if($(this).hasClass(a.attr('class'))){
                      $(this).addClass('active');
                    }else{
                      $(this).removeClass('active');
                    }
                  }
                );
                $(this).addClass('accesibilidad-'+a.attr('class'));
              }
            );
            e.preventDefault();
          });
  });
});
