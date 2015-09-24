// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$( "#rfq_est_production_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	
});

//for customer field autocomplete on new rfq view.
$(function() {
    return $('#rfq_customer_name').autocomplete({
        minLength: 1,
        source: $('#rfq_customer_name').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#rfq_customer_name').val(ui.item.value);
        },
    });
});

$(function() {
  $('#rfq_customer_name').change(function (){
  	$('#rfq_field_changed').val('customer_name');
    $.get(window.location, $('form').serialize(), null, "script");
    return false;
  });
});

$(function() {
  $('#rfq_copy_rfq_id').change(function (){
  	$('#rfq_field_changed').val('copy_rfq');
    $.get(window.location, $('form').serialize(), null, "script");
    return false;
  });
});