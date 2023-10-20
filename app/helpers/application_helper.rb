# frozen_string_literal: true

module ApplicationHelper
  def yes_no(value)
    tag.span (value ? 'Yes' : 'No'), class: (value ? 'text-success' : 'text-danger')
  end
end
