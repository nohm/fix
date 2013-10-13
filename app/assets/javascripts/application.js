// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

$(document).on('page:change', function(){

    if ($('#entry_appliance_id').length != 0) {
        setIndex($('#entry_appliance_id')[0].selectedIndex);
        $('#entry_appliance_id').change(function() {
            setIndex($('#entry_appliance_id')[0].selectedIndex);
        });
        $('#entry_number').css({
            width: $('#entry_number').width() - $('#entry_number').siblings('.add-on').width() - 10
        });
    }

    function setIndex(index) {
      $('#entry_number').siblings('.add-on').html($('#app_abb').html().split(',')[index]);
      $('#entry_number')[0].value = $('#app_num').html().split(',')[index];
    }

    if ($('#filter-toggle').length != 0) {
    	var filtered = false;

        $('#filter-toggle').click(function() {
        	$('#filter').val('');
        	if (filtered) {
            	$('.searchable tr').show();
            	filtered = false;
        	}
        	$('#filter').toggle();
        });

        $('#filter').keyup(function() {
            var rex = new RegExp($(this).val(), 'i');
            $('.searchable tr').hide();
            $('.searchable tr').filter(function() {
                return rex.test($(this).text());
            }).show();
            filtered = true;
        });
    }
});