# frozen_string_literal: true

module BusStopsHelper
  def check_image(attribute)
    tag.span nil, class: "glyphicon glyphicon-#{attribute ? 'ok' : 'remove'}"
  end
end
