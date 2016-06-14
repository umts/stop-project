module DateAndTimeMethods
  def format_datetime(datetime)
    datetime.strftime('%A, %B %e, %Y - %l:%M %P').squish
  end
end
