$(document).ready(function(){
  $('.name-autocomplete').autocomplete({
    source: searchStops
  });
});

function searchStops(request, response){
  $.post('/bus_stops/autocomplete', request, response);
}
