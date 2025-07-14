class OnboardingHeaderComponent < ViewComponent::Base
  def initialize(title:, description: nil, **props)
    @title = title
    @description = description
    @props = props
  end

  private

  attr_reader :title, :description, :props

  def title_classes
    "text-xl font-semibold mb-1 text-text"
  end

  def description_classes
    "text-muted-foreground mb-6"
  end
end