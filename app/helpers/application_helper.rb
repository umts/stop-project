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

  def yes_no(value)
    tag.span (value ? 'Yes' : 'No'), class: (value ? 'text-success' : 'text-danger')
  end
end
