$(function() {
    $("#select_all").toggle(function() {
   	  $(".pub-state-checkbox").each(function() {
	      this.checked = 'checked';
	    });
	   }, function() {
	    $(".pub-state-checkbox").each(function() {
	      this.checked = '';
	    });
    });

		// update tag
		$('.tag_field form').change(function() {
			$.post($(this).action,$(this).serialize(),function(data){
				
			}, function(error){
				alert('Sorry there has been an error updating this event');
			});
		});
});