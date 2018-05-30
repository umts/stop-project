module ApplicationHelper

  def display_name(stop)
    if stop.name.present? then stop.name
    else 'New stop'
    end
  end
end
