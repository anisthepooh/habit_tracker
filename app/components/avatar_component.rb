# frozen_string_literal: true

class AvatarComponent < ViewComponent::Base
  SIZES = {
    xs: {
      avatar: "h-6 w-6",
      text: "text-xs",
      indicator: "w-2 h-2",
      position: "-bottom-0.5 -right-0.5"
    },
    sm: {
      avatar: "h-8 w-8",
      text: "text-sm",
      indicator: "w-3 h-3",
      position: "bottom-0 -right-1"
    },
    md: {
      avatar: "h-12 w-12",
      text: "text-base",
      indicator: "w-3.5 h-3.5",
      position: "-bottom-0.5 -right-0.5"
    },
    lg: {
      avatar: "h-16 w-16",
      text: "text-lg",
      indicator: "w-4 h-4",
      position: "bottom-0.5 right-0.5"
    },
    xl: {
      avatar: "h-20 w-20",
      text: "text-xl",
      indicator: "w-5 h-5",
      position: "-bottom-1 -right-1"
    },
    "2xl": {
      avatar: "h-24 w-24",
      text: "text-2xl",
      indicator: "w-6 h-6",
      position: "-bottom-1.5 -right-1.5"
    }
  }.freeze

  def initialize(user:, size: :sm, show_status: true)
    @user = user
    @size = size.to_sym
    @show_status = show_status

    raise ArgumentError, "Invalid size: #{@size}. Available sizes: #{SIZES.keys.join(', ')}" unless SIZES.key?(@size)
  end

  private

  attr_reader :user, :size, :show_status

  def size_config
    SIZES[size]
  end

  def avatar_classes
    "#{size_config[:avatar]} rounded-full object-cover bg-white/10 backdrop-blur-xl"
  end

  def placeholder_classes
    "#{size_config[:avatar]} rounded-full bg-gray-100 flex items-center justify-center text-muted-foreground #{size_config[:text]} font-semibold"
  end

  def user_initial
    user.first_name&.first&.upcase || "?"
  end

  def status_indicator_class
    return unless show_status

    base_classes = "absolute #{size_config[:position]} #{size_config[:indicator]} border-2 border-white rounded-full"

    case status_type
    when :online
      "#{base_classes} bg-green-500"
    when :away
      "#{base_classes} bg-yellow-500"
    else
      "#{base_classes} bg-gray-400"
    end
  end

  def status_type
    return :offline unless user.last_signed_in_at

    if user.last_signed_in_at > 15.minutes.ago
      :online
    elsif user.last_signed_in_at > 24.hours.ago
      :away
    else
      :offline
    end
  end

  def show_status_indicator?
    show_status && status_indicator_class.present?
  end
end
