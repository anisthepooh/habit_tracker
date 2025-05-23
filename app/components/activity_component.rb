# frozen_string_literal: true

class ActivityComponent < ViewComponent::Base
  VARIANT_CLASSES = {
    default: "!text-gray-500 !bg-gray-100",
    success: "!text-green-600 !bg-green-100",
    error: "!text-red-600 !bg-red-100",
    warning: "!text-yellow-600 !bg-yellow-100",
    info: "!text-blue-600 !bg-blue-100"
  }.freeze

  def initialize(title:, subtitle: nil, icon: nil, variant: :default, date: nil)
    @title = title
    @subtitle = subtitle
    @icon = icon
    @variant = variant.to_sym
    @date = date
  end

  def icon_class
    VARIANT_CLASSES[@variant] || VARIANT_CLASSES[:default]
  end
end
