class StatCardComponent < ViewComponent::Base
  def initialize(title:, count:, data_description:, growth_in_procent: nil, icon: nil, **props)
    @title = title
    @count = count
    @data_description = data_description
    @growth_in_procent = growth_in_procent
    @icon = icon
    @props = props
  end

  private

  attr_reader :title, :count, :data_description, :growth_in_procent, :icon, :props

  def component_classes
    custom_classes = props[:class] || ""
    base_classes = "bg-white p-6 rounded-xl shadow hover:shadow-md transition"
    
    [base_classes, custom_classes].compact.join(" ")
  end

  def show_growth?
    growth_in_procent.present?
  end

  def show_icon?
    icon.present?
  end
end