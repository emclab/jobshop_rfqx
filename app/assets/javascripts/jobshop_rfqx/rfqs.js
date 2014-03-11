// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$( "#rfq_est_production_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	
});

//for customer field autocomplete on new rfq view.
$(function() {
    return $('#rfq_customer_name_autocomplete').autocomplete({
        minLength: 1,
        source: $('#rfq_customer_name_autocomplete').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#rfq_customer_name_autocomplete').val(ui.item.value);
        },
    });
});