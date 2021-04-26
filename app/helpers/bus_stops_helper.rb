module BusStopsHelper
  def check_image(attribute)
    if attribute
      content_tag :span, nil, class: 'glyphicon glyphicon-ok'
    else content_tag :span, nil, class: 'glyphicon glyphicon-remove'
    end
  end
end
