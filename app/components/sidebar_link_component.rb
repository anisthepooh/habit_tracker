class SidebarLinkComponent < ViewComponent::Base
  def initialize(path:, icon:, label:, active: false, external: false, **props)
    @path = path
    @icon = icon
    @label = label
    @active = active
    @external = external
    @props = props
  end

  private

  attr_reader :path, :icon, :label, :active, :external, :props

  def link_classes
    base_classes = "flex items-center justify-start w-full gap-2 rounded-md px-2 py-2 font-medium text-sm"
    
    if active
      "#{base_classes} bg-gray-200"
    else
      "#{base_classes} hover:opacity-80 hover:bg-gray-100"
    end
  end

  def link_options
    options = { class: link_classes }
    options[:target] = "_blank" if external
    options.merge(props)
  end
end