class ButtonComponent < ViewComponent::Base
  def initialize(variant: :default, size: :default, **props)
    @variant = variant
    @size = size
    @props = props
  end

  def component_classes
    custom_classes = @props.delete(:class)

    button_variants = {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90 w-full ",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline: "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline"
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10"
      }
    }

    base_classes = "text-sm inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 cursor-pointer"

    variant_class = button_variants[:variant].fetch(@variant, button_variants[:variant][:default])
    size_class = button_variants[:size].fetch(@size, button_variants[:size][:default])

    [ base_classes, variant_class, size_class, custom_classes ].compact.join(" ")
  end


  def call
    tag.button content, class: component_classes, **@props
  end
end
