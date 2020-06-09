$(document).ready(function(){
  $('.name-autocomplete').autocomplete({
    source: searchStops,
    select: stopSelected
  });

  $('.datepick').datepicker({
    dateFormat: 'yy-mm-dd'
  });
});

function searchStops(request, response){
  $.post('/bus_stops/autocomplete', request, response);
}

function stopSelected(event, ui) {
  window.location = 'bus_stops/' + ui.item.hastus_id + '/edit';
}
