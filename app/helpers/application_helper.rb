module ApplicationHelper

  def display_name(item)
    case item
    when User
      item.name.present? ? item.name : 'New user'
    when BusStop
      item.name.present? ? item.name : 'New stop'
    end
  end
end
