// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {	
	$(".event .attend-button").fancybox({
		'width'				: '90%',				
		'height'			: '90%',				
		'autoScale'			: true,				
		'transitionIn'		: 'none',			
		'transitionOut'		: 'none',				
		'type'				: 'iframe'			
	});
	$(".event .map-link").fancybox({
		'width'				: '90%',				
		'height'			: '90%',				
		'autoScale'			: true,				
		'transitionIn'		: 'none',			
		'transitionOut'		: 'none',				
		'type'				: 'iframe'			
	});
	
	// Highlight starred on hover!
	$(".star a.starred").hover(function() {
		$("img", this).attr("src", "/images/starred.gif");
	}, function() {
		$("img", this).attr("src", "/images/starred_dim.gif");
	});

	// Highlight star on hover!
	$(".star a.unstarred").hover(function() {
		$("img", this).attr("src", "/images/star.gif");
	}, function() {
		$("img", this).attr("src", "/images/star_dim.gif");
	});
	
	var slide = function(event,context,up) {
		var isClickable = ['title','event','preview'].some(function(clazz){return $(event.target).hasClass(clazz);});
		if(isClickable) {
			console.log(up ? 'slideUp' : 'slideDown');
			$('.preview',context)[ up ? 'slideUp' : 'slideDown']();
		}
	};
	
	$('.event .title').toggle(function(event){
		$('.comments', $(this).parent()).html('<fb:comments xid="' + $(this).parent().attr("id") + '" numposts="3" width="300"></fb:comments>');
		//alert(this.parent().id.replace("event", "comments"));
		FB.XFBML.parse(document.getElementById($(this).parent().attr("id").replace("event", "comments")));
		$(".comments", $(this).parent()).show();
		this.title = "Show less info";
		slide(event, $(this).parent(), false);
	},function(event){
		slide(event, $(this).parent(), true);
		this.title = "Show more info";
		$(".comments", $(this).parent()).hide();
	});
});