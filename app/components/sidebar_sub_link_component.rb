class SidebarSubLinkComponent < ViewComponent::Base
  def initialize(path:, icon:, label:, active: false, **props)
    @path = path
    @icon = icon
    @label = label
    @active = active
    @props = props
  end

  private

  attr_reader :path, :icon, :label, :active, :props

  def link_classes
    base_classes = "flex items-center gap-2 rounded-md px-2 py-2 text-sm text-gray-600 hover:bg-gray-100 hover:text-gray-900"
    
    if active
      "#{base_classes} bg-gray-100 text-gray-900"
    else
      base_classes
    end
  end

  def link_options
    { class: link_classes }.merge(props)
  end
end