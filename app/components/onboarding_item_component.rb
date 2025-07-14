class OnboardingItemComponent < ViewComponent::Base
  def initialize(path:, title:, description:, onboarding_key:, **props)
    @path = path
    @title = title
    @description = description
    @onboarding_key = onboarding_key
    @props = props
  end

  private

  attr_reader :path, :title, :description, :onboarding_key, :props

  def link_classes
    base_classes = "flex items-center gap-4 border border-border rounded-2xl p-4"
    custom_classes = @props.delete(:class)
    
    [base_classes, custom_classes].compact.join(" ")
  end

  def link_options
    { class: link_classes }.merge(@props)
  end

  def has_completed?
    Current.user.has_completed_onboarding?(@onboarding_key)
  end

  def has_seen?
    Current.user.has_seen_onboarding?(@onboarding_key)
  end

  def status_text
    if has_completed?
      "Completed"
    elsif has_seen?
      "Viewed"
    else
      nil
    end
  end

  def status_icon
    if has_completed?
      "check"
    elsif has_seen?
      "eye"
    else
      nil
    end
  end

  def status_classes
    if has_completed?
      "text-xs text-black font-medium mt-1 inline-flex gap-1"
    elsif has_seen?
      "text-xs text-gray-600 font-medium mt-1 inline-flex gap-1"
    else
      ""
    end
  end

  def completion_icon
    if has_completed?
      "circle-check"
    else
      "circle"
    end
  end

  def completion_icon_classes
    if has_completed?
      "w-8 h-8 !text-white bg-black rounded-full"
    else
      "w-8 h-8 text-muted-foreground"
    end
  end
end