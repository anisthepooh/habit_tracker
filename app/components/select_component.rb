# frozen_string_literal: true

class SelectComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(form:, field:, selected: nil, options: [], **html_options)
    @form = form
    @field = field
    @selected = selected
    @options = options
    @html_options = html_options
  end

  private

  attr_reader :form, :field, :selected, :options, :html_options

  def selected_option
    options.find { |option| option[:value] == selected } || options.first
  end

  def field_name
    "#{form.object_name}[#{field}]"
  end

  def component_id
    "select-#{field}-#{SecureRandom.hex(4)}"
  end

  def render_icon(icon_value)
    return "" if icon_value.blank?

    # Check if it's an emoji (contains non-ASCII characters)
    if icon_value.match?(/[^\x00-\x7F]/)
      content_tag(:span, icon_value, class: "text-lg")
    else
      # It's a Lucide icon name
      lucide_icon(icon_value, class: "w-5 h-5")
    end
  end

  def use_native_select?
    ios_device?
  end
end
