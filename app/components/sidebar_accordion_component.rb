class SidebarAccordionComponent < ViewComponent::Base
  def initialize(icon:, label:, open: false, controller_active: false, **props)
    @icon = icon
    @label = label
    @open = open
    @controller_active = controller_active
    @props = props
  end

  private

  attr_reader :icon, :label, :open, :controller_active, :props

  def button_classes
    base_classes = "flex items-center justify-between w-full gap-2 rounded-md px-2 py-2 font-medium text-sm"
    
    if controller_active
      "#{base_classes} bg-gray-200"
    else
      "#{base_classes} hover:opacity-80 hover:bg-gray-100"
    end
  end
end