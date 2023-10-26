# frozen_string_literal: true

module ApplicationHelper
  def yes_no(value)
    tag.span (value ? 'Yes' : 'No'), class: (value ? 'text-success' : 'text-danger')
  end

  def nav_item(name, options = nil, html_options = nil, &block)
    html_options = (html_options || {}).merge({ class: 'nav-link' })
    tag.li class: ['nav-item', (current_page?(options) ? 'active' : nil)] do
      link_to name, options, html_options, &block
    end
  end
end
