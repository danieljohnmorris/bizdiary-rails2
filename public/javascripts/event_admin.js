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
    $('.tag_form').change(function() {
			$(this).submit();
    });
});