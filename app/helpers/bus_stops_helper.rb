module BusStopsHelper

  def check_image(attribute)
    if attribute
      content_tag :span, nil, class: 'glyphicon glyphicon-ok'
    else content_tag :span, nil, class: 'glyphicon glyphicon-remove'
    end
  end

  def display_name(stop)
    if stop.name.present? then stop.name
    else 'New stop'
    end
  end
end
