# frozen_string_literal: true

module ApplicationHelper
  def display_name(item)
    case item
    when User
      item.name || 'New user'
    when BusStop
      item.name || 'New stop'
    end
  end
end
