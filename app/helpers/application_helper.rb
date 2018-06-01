module ApplicationHelper

  def display_name(item)
    case item.class
    when User then item.name.present? ? item.name : 'New user'
    when BusStop then item.name.present? ? item.name : 'New stop'
    end
  end
end
