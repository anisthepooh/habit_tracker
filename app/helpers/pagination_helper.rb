# app/helpers/pagination_renderer.rb
module PaginationHelper
  class Pagination < WillPaginate::ActionView::LinkRenderer
    def container_attributes
      { class: "flex items-center justify-center mt-6 space-x-2" }
    end

    def page_number(page)
      if page == current_page
        tag(:span, page, class: "px-4 py-2 text-sm font-medium rounded-xl bg-primary text-primary-foreground shadow")
      else
        link(page, page, class: "px-4 py-2 text-sm font-medium rounded-xl hover:bg-muted transition")
      end
    end

    def previous_or_next_page(page, text, classname)
      disabled = page.nil?
      base_classes = "px-3 py-2 text-sm rounded-xl"

      if disabled
        tag(:span, text, class: "#{base_classes} opacity-50 cursor-not-allowed")
      else
        link(text, page, class: "#{base_classes} hover:bg-muted transition")
      end
    end

    def gap
      tag(:span, "...", class: "px-4 py-2 text-muted-foreground text-sm")
    end
  end
end
