$(document).ready(function(){
  $('.name-autocomplete').autocomplete({
    source: searchStops
  });

  $('.datepick').datepicker({
    dateFormat: 'yyyy-mm-dd'
  })
});

function searchStops(request, response){
  $.post('/bus_stops/autocomplete', request, response);
}
