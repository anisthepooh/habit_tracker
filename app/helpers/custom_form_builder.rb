class CustomFormBuilder < ActionView::Helpers::FormBuilder
  BASE_INPUT_CLASSES = "flex h-10 w-full rounded-md border border-input bg-input shadow-none px-3 py-2 text-base ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"


  def text_field(method, options = {})
    options[:class] = merge_classes(options[:class], BASE_INPUT_CLASSES)
    super(method, options)
  end

  def email_field(method, options = {})
    options[:class] = merge_classes(options[:class], BASE_INPUT_CLASSES)
    super(method, options)
  end

  def password_field(method, options = {})
    options[:class] = merge_classes(options[:class], BASE_INPUT_CLASSES)
    super(method, options)
  end

  def number_field(method, options = {})
    options[:class] = merge_classes(options[:class], BASE_INPUT_CLASSES)
    super(method, options)
  end

  def datetime_field(method, options = {})
    options[:class] = merge_classes(options[:class], BASE_INPUT_CLASSES)
    super(method, options)
  end

  def date_field(method, options = {})
    options[:class] = merge_classes(options[:class], BASE_INPUT_CLASSES)
    super(method, options)
  end

  def label(method, text = nil, options = {}, &block)
    options[:class] = merge_classes(
      options[:class],
      "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
    )
    super(method, text, options, &block)
  end

  def check_box (method, options = {})
    options[:class] = merge_classes(options[:class], "w-4 h-4 text-primary bg-gray-100 border-gray-300 rounded-sm focus:ring-blue-500")
    super(method, options)
  end

  def textarea(method, options = {})
    adjusted_classes = BASE_INPUT_CLASSES.gsub("h-10", "min-h-[120px] resize-y")
    options[:class] = merge_classes(options[:class], adjusted_classes)
    super(method, options)
  end



  private

  def merge_classes(existing_classes, new_classes)
    [ existing_classes, new_classes ].compact.join(" ")
  end
end
