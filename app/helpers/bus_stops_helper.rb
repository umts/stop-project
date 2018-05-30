module BusStopsHelper

  def check_image(attribute)
    if attribute
      content_tag :span, nil, class: 'glyphicon glyphicon-ok'
    else content_tag :span, nil, class: 'glyphicon glyphicon-remove'
    end
  end

  def creation_url(stop)
    if stop.new_record? then bus_stops_path
    else bus_stop_path stop.hastus_id
    end
  end
end
