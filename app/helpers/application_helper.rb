module ApplicationHelper

  def display_name(item)
    case item
    when :user then item.name.present? ? item.name : 'New user'
    when :stop then item.name.present? ? item.name : 'New stop'
    end
  end
end
