(function($) {
	Drupal.behaviors.buenosAires = {
		attach: function (context, settings) {
	  /*$('#carousel-ba').carousel({interval: false});
	  $('#galleryModal-ba').carousel({interval: false});*/
	  $('#galleryModal').carousel({ interval:false });
	  $('#gallery').carousel({ interval:false });

	  /* modal carousel gallery full screen v3 */
	  $('#galleryModal').modal();
	  $('#galleryModal').modal('hide');
	  $('.row-gallery > a').each(function(i) {
		var $itemTemplate = $('<div class="item"> <img src="{img}" alt="{alt}"><div class="item-info"><h3></h3><p></p></div> </div>');
		$itemTemplate.find('img').attr('src', $(this).attr('href'));
		//UTILIZA TITLE COMO TITULO Y ALT SI NO TIENE DEFINIDOS COMO EN GALERÍA
		$itemTemplate.find('.item-info h3').html($(this).find('img').attr('title'));
		$itemTemplate.find('.item-info p').html($(this).find('img').attr('alt'));
		//SI ES UNA GALERÍA Y TIENE DEFINIDOS LOS REEMPLAZA
		if($(this).find('.info h3').length){$itemTemplate.find('.item-info h3').html($(this).find('.info h3'));}
		if($(this).find('.info p').length){$itemTemplate.find('.item-info p').html($(this).find('.info p'));}
		if(i==0){$itemTemplate.addClass('active');}
		$('#gallery .carousel-inner').append($itemTemplate);
	});

	  //Toma los ids de los elementos para indexarlos bonito
	  $('.row-gallery > a').click(function(event){
		var index = parseInt($(this).attr('id'));
		$('#galleryModal').modal('show');
		$('#galleryModal').carousel(index);
		event.preventDefault();
	  });

	  //Muestra en 2 columnas el formatter full carousel v3 si está al costado
	  $('div.container > div.panel-panel.panel-bastrap-4.col-md-4.col-sm-4.col-xs-12 .row-gallery a').each(function(){
		$(this).removeClass('col-md-3');
		$(this).addClass('col-md-6');
	  });

	  //Este fix porque el comportamiento natural de carousel pelea con el anchor de drupal behaviours
	  $('div[data-slide="prev"]').css( 'cursor','pointer' );
	  $('div[data-slide="next"]').css( 'cursor','pointer' );
	  $('div[data-slide="prev"]').click(function() {
		$('#galleryModal').carousel('prev');
	  });
	  $('div[data-slide="next"]').click(function() {
		$('#galleryModal').carousel('next');
	  });

	  /* Resize imagenes en menu y ocultarlo cuando hagas resize de la ventana */
	  $('.nav .dropdown').on('show.bs.dropdown', function(){ 
		var height = $(this).find('.dropdown-menu').height();
		$(this).find('.col-menu-img').height( height );
	  })
	  $('.nav .dropdown').on('close.bs.dropdown', function(){ 
		$(this).find('.col-menu-img').height(0);
	  })
	  $(window).resize(function(){
		$('.nav .dropdown').removeClass('open');
		$('.nav .dropdown').find('.col-menu-img').height(0);
	  })

	  $(function(){
		$('.nav .dropdown .main-menu').hover(function() {
			$(this).parent().toggleClass('keepopen');
		});
	  });

	  $('.nav .dropdown').on('hide.bs.dropdown', function (e) {
		var target = $(e.target);
		if(target.hasClass("keepopen") || target.parents(".keepopen").length){
			  return false; // returning false should stop the dropdown from hiding.
		  }else{
			return true;
		  }
	  });
	  
	  /* fin resize imagen menu*/

	  /* widget-map scroll fix */
	  $('.widget-embed').click(function () {
		$('.widget-map').css("pointer-events", "auto");
	  });

	  /* Tooltips */
	  $('[data-toggle="tooltip"]').tooltip();

	  $('.pager-previous a').addClass( "glyphicon glyphicon-chevron-left" );
	  $('.pager-next a').addClass( "glyphicon glyphicon-chevron-right" );

	  $('#recaptcha_options').find('li').addClass('btn btn-default');

	  $('.col-md-12 #bweb-tramites-block-form').parent().removeClass('list-form');
	  $('.col-md-12 #bweb-tramites-block-form').wrap('<section class="search-xl" id="atencion"></section>');
	  $('.col-md-12 #bweb-tramites-block-form #edit-keys').addClass('input-xl');
	  $iframes = $('iframe.embed-responsive-item');
	  if($iframes) {
		$iframes.each(function(){
			jQuery(this).wrap('<div class="embed-responsive embed-responsive-16by9"></div>');
		});
	  }
	  /* Le agrega título a las imágenes inline del body */
	  
	  $('.pane-node-body img').each(function(){
		var img = $(this);
		var titulo = $('<figcaption>');
		var contenedor = $('<figure>');
		if(typeof img.attr('title') != 'undefined' && img.attr('title').length>0){
			img.wrap(contenedor);
			titulo.text(img.attr('title'));
			titulo.insertAfter(img);
		}
	  });
	  $('.dropdown-toggle').dropdown();
	  //Arregla los collapse que no andan del sitio en telefonos
	  $('.navbar-toggle').click(function(e){
		$($(this).attr('data-target')).toggleClass('in');
		// $('#lupa-box').fadeToggle('fast'); 
		$('.chat-header').fadeToggle('fast');
		if($('.img-reduce').css('float')=="left" ){  $('.img-reduce').css('float', 'none');  }else{ $('.img-reduce').css('float', 'left');  }
		e.stopPropagation();
	});
	  
	  //menu home mobile
	  $('.home-nav .container li a').each(function(){
		$(this).addClass('btn btn-default btn-lg btn-block');
		if($(this).hasClass('active')){
			$(this).removeClass('active');
		}
	  });
	  
	  /* 2016 */
	  /*$('#finder').click( function() {
		//si el campo de busqueda esta escondido has:
		if($('#div-search-box').css('display')=="none" ){
		  $('.navbar-list-secondary').fadeOut('fast');//menu
		  setTimeout("search_box()", 400);
	  }
  });*/

	  $("#edit-keys--2").keypress( function(e){
		if(e.keyCode==27){//esc
			$('#div-search-box').fadeOut('fast'); 
			setTimeout("show_sub_menu()", 500); 
			$('#div-lupa').removeClass('hidden'); 
		}
	});

	  //Si el campo esta vacio, vuelve a mostrar el menu
	  $("#edit-submit--3").click( function(){
		if( ($("#edit-keys--2").val()=="") ){//campo vacio pagina principal
			
			if($(window).width()>767){
				$('#div-search-box').fadeOut('fast'); 
				setTimeout("show_sub_menu()", 500); 
				$('#div-lupa').removeClass('hidden');
			}
			return false;
		}
	});
	  $("#edit-submit--2").click( function(){//cuando esta en otra pagina
		
		if( $("#edit-keys").val()==""){//campo vacio
			if($(window).width()>767){
				
				$('#div-search-box').fadeOut('fast'); 
				setTimeout("show_sub_menu()", 500); 
				$('#div-lupa').removeClass('hidden');
			}
			return false;
		}
		
	});
	  //Depende del id del form
	  $("#gcaba_drupal_form_result_"+$(".gcaba-drupal-form-render-form").attr("data-id") ).css("padding-top", "50px");

	  /* $(".navbar-toggle").click( function(){
			  $('#lupa-box').fadeToggle('fast'); 
		  });*/

	  //FACEBOOK PARCHE PARA COMPARTIR USANDO APLICACION MIENTRAS SE ARREGLAN LAS REDIRECCIONES
	  /*$('a.social-fb.facebook').bind('click', function(e){
		var titulo= "Buenos Aires";
		var imagen="http://www.buenosaires.gob.ar/sites/gcaba/themes/gcbaV3/gcaba/assets/menu/47778.jpg";
		var description= "Sitio oficial del Gobierno de la Ciudad de Buenos Aires, Argentina. Información general, tramites, servicios, agenda, mapas y aplicaciones.";
		var link= "http://www.buenosaires.gob.ar";
		if($('meta[property="og:title"]').length){titulo=$('meta[property="og:title"]').attr('content');}
		if($('meta[property="og:image"]').length){imagen=$('meta[property="og:image"]').attr('content');}
		if($('meta[property="og:description"]').length){description=$('meta[property="og:description"]').attr('content');}
		if($('meta[property="og:url"]').length){link=$('meta[property="og:url"]').attr('content');}
		e.preventDefault();
		url = "https://www.facebook.com/dialog/feed?app_id=1640342939574431" + 
					  "&link=" + encodeURIComponent(link.replace(/gcaba/gi, "buenosaires.gob.ar"))+ 
					  "&name=" + encodeURIComponent(titulo) + 
					  "&caption=" + encodeURIComponent('Compartido desde BuenosAires.gob.ar') + 
					  "&description=" + encodeURIComponent(description) + 
					  "&picture=" + imagen +
					  "&redirect_uri=https://www.facebook.com";
					  console.log(url);
		window.open(url);
	});*/
	
  	$("#edit-openid-connect-client-login-container").removeClass("pull-right");
  	
  	if(jQuery(window).width()<767){
  		setTimeout("search_box()", 100); 
  	};
  }
};

})(jQuery);

var timeOutHeader;

jQuery(document).ready(function(){
	// Buscador del header DESKTOP

	jQuery('#search span').on('click', function(event){
		event.stopPropagation();
		var status = jQuery('.mainNavbar .inputSearch').css('display');
		if(status == 'none'){
			jQuery('#container-search-navbar').stop();

			jQuery('#container-search-navbar').fadeOut(250, function(){

				jQuery('.mainNavbar .inputSearch').fadeIn(250, function(){

					timeOutHeader = setTimeout(function(){
						jQuery('.mainNavbar .inputSearch').fadeOut(250, function(){
							jQuery('#container-search-navbar').fadeIn(250);
						});
					}, 5000);

				});

			});
			
		}
	});

	// Buscador del header RESPONSIVE

	jQuery('#searchMainNavbar button').on('click', function(){
		var status = jQuery('.logoBABAC').css('display');
		if(status == 'block'){
			jQuery('#searchMainNavbar, .logoBABAC').stop();

			jQuery('#searchMainNavbar').fadeOut(250);
			jQuery('.logoBABAC').fadeOut(250, function(){

				jQuery('.mainNavbar .inputSearch').fadeIn(250, function(){

					timeOutHeader = setTimeout(function(){
						jQuery('.mainNavbar .inputSearch').fadeOut(250, function(){
							jQuery('#searchMainNavbar').fadeIn(250);
							jQuery('.logoBABAC').fadeIn(250);
						});
					}, 5000);

				});

			});

		}

	});

	jQuery('.navbar-accesible button.navbar-toggle').on('click', function(){
		var status = jQuery('.navbar-accesible button.navbar-toggle span').css('display');
		if(status == 'block'){
			jQuery('.navbar-accesible button.navbar-toggle span').stop();
			jQuery('.navbar-accesible button.navbar-toggle span.icon-menu').fadeOut(250, function(){
				jQuery('.navbar-accesible button.navbar-toggle span.icon-close').fadeIn(250);
			});
		}
		else{
			jQuery('#searchMainNavbar button.navbar-toggle span').stop();
			jQuery('.navbar-accesible button.navbar-toggle span.icon-close').fadeOut(250, function(){
				jQuery('.navbar-accesible button.navbar-toggle span.icon-menu').fadeIn(250);
			});
		}
	});
});

function close_bweb_header(){
	clearTimeout(timeOutHeader);
	// Responsive
	jQuery('.mainNavbar .inputSearch').fadeOut(250, function(){
		if(window.innerWidth <= 992){
			jQuery('#searchMainNavbar').fadeIn(250);
			jQuery('.logoBABAC').fadeIn(250);
		}
		else{
			jQuery('#container-search-navbar').fadeIn(250);
		}

	});

}

function search_box(){
	jQuery('#edit-openid-connect-client-login-container').removeClass('pull-right');
	jQuery('#div-search-box').fadeIn('slow');
	jQuery('#div-lupa').addClass('hidden');//esconder lupa del solr
	jQuery('#lupa-box').addClass('lup-box');
	//depende de si se llama al modulo mas de una vez en la misma pagina, se cambian los nombres...
  if(jQuery('#edit-keys--2').val()!=undefined ){// desde el index., se llama dos veces el modulo bweb, por eso cambian los ID
	jQuery('#edit-keys--2').prop('placeholder', '¿Qué estás buscando?..');
	jQuery('#edit-keys--2').removeClass('form-control');
	jQuery('#edit-keys--2').addClass('key-not');
	jQuery('#edit-keys--2').focus();
	jQuery('#edit-submit--3').addClass('btn-lp');

  }else{//desde otra pagina que no sea el index
	jQuery('#edit-keys').prop('placeholder', '¿Qué estás buscando?..');
	jQuery('#edit-keys').removeClass('form-control');
	jQuery('#edit-keys').addClass('key-not');
	jQuery('#edit-keys').focus();
	jQuery('#edit-submit--2').addClass('btn-lp');
	jQuery('#edit-submit--3').addClass('btn-lp');
  }
  setTimeout("show_search_box()",5000); 
}

function show_search_box(){
  if( jQuery(".key-not").val()==""){//campo vacio
	if(jQuery(window).width()>767){
		jQuery('#div-search-box').fadeOut('fast'); 
		setTimeout("show_sub_menu()", 500); 
	}
	return false;
  }
}

function show_sub_menu(){
	jQuery('.navbar-list-secondary').fadeIn('slow'); 
}