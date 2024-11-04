# frozen_string_literal: true

module ApplicationHelper
  def yes_no(value)
    tag.span (value ? 'Yes' : 'No'), class: (value ? 'text-success' : 'text-danger')
  end

  def nav_item(name, options = nil, html_options = {}, &)
    html_options = html_options.tap do |opts|
      opts[:class] = Array(opts[:class]).push 'nav-link', (current_page?(options) ? 'active' : nil)
    end

    tag.li class: 'nav-item' do
      link_to(name, options, html_options, &)
    end
  end
end
