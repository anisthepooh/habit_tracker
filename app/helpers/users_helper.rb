module UsersHelper
  def image_radio_group(form, label:, images:, group:)
    content_tag(:div, class: "mb-6 pb-3") do
      concat(
        content_tag(:div, class: "grid grid-cols-3 gap-4 bg-white rounded-2xl p-4") do
          images.each_with_index.map do |image_src, index|
            radio_id = "#{group}_image_#{index}"

            content_tag(:div, class: "relative flex-grow min-w-[75px]") do
              form.radio_button(:card_background, image_src, id: radio_id, class: "hidden peer", data: { action: "preview#update", preview_icon_value: image_src }) +
              content_tag(:label, for: radio_id, class: "flex opacity-80 overflow-hidden relative items-center justify-center w-full h-12 aspect-square rounded-xl border transition-all cursor-pointer
                          bg-white border-gray-200 text-gray-500
                          peer-checked:outline peer-checked:opacity-100 peer-checked:shadow-lg peer-checked:outline-stone-800 peer-checked:outline-2
                          hover:border-muted hover:bg-muted") do
                if image_src == "blank"
                  content_tag(:div, nil, class: "w-full h-full object-cover absolute top-0 left-0 right-0 bg-primary")
                else
                  image_tag(image_src, alt: "", class: "w-full h-full object-cover absolute top-0 left-0 right-0")
                end
              end
            end
          end.join.html_safe
        end
      )
    end
  end
end
