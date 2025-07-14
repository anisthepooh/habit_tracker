class OnboardingStepComponent < ViewComponent::Base
  def initialize(step_number:, **props)
    @step_number = step_number
    @props = props
  end

  private

  attr_reader :step_number, :props

  def step_header_classes
    "w-full py-2 bg-gray-100 rounded-md px-2 font-medium mt-1"
  end

  def step_title
    "Step #{@step_number}"
  end
end