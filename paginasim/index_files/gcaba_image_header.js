//Agregue esto porque sino los modulos que reemplazan con jquery 1.10 no cargan los menús esto es compatible con 1.8
(function($) {
  Drupal.behaviors.gcaba_image_header = {
    attach: function (context, settings) {
	jQuery('li.first.leaf').removeClass('first leaf');
	jQuery('li.leaf').removeClass('leaf');
	jQuery('li.last').removeClass('last');
	jQuery('span.nolink').removeClass('nolink');

	jQuery('li.last.leaf').removeClass('last leaf').addClass('dropdown');
	jQuery('li.active.trail').removeClass('active-trail').addClass('dropdown');
	jQuery('li.first.expanded').removeClass('first expanded').addClass('dropdown');
	jQuery('li.expanded.active-trail').removeClass('expanded active-trail').addClass('dropdown');
	jQuery('li.expanded').removeClass('expanded').addClass('dropdown');

	jQuery('li.first.expanded.active-trail').removeClass('first expanded active-trail').addClass('dropdown-open');
	jQuery('li.last.expanded').removeClass('last expanded').addClass('dropdown-open');

	jQuery('a.active-trail.active').removeClass('active-trail active').addClass('dropdown-toggle').attr('data-toggle', 'dropdown');

	jQuery('div.navbar-collapse ul:first-child').addClass('nav navbar-nav');
	jQuery('div.navbar-collapse ul').not(':first').addClass('dropdown-menu');
	jQuery('.navbar-nav li span').wrap("<a href='#' class='dropdown-toggle' data-toggle='dropdown'></a>");
	jQuery('#header-sub-nav > ul li.dropdown').each(function(){
		var caret = jQuery('<b>');
		caret.attr('class','caret');
		jQuery(this).children('a').append(caret);
		jQuery(this).children('a').addClass('dropdown-toggle');
		jQuery(this).children('a').attr('data-toggle','dropdown');
	})
    }
  };
})(jQuery);