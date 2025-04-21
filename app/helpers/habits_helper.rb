module HabitsHelper
  def icon_radio_group(form, label:, icons:, group:)
    content_tag(:div, class: "mb-6 pb-3") do
      concat form.label(:icon, label, class: "block font-medium text-gray-700 mb-2 capitalize")

      concat(
        content_tag(:div, class: "flex flex-wrap gap-4 bg-white rounded-2xl p-4") do
          icons.each_with_index.map do |icon, index|
            radio_id = "#{group}_icon_#{index}"

            content_tag(:div, class: "relative") do
              form.radio_button(:icon, icon, id: radio_id, class: "hidden peer", data: { action: "preview#update", preview_icon_value: icon }) +
              content_tag(:label, for: radio_id, class: "flex items-center justify-center w-12 h-12 aspect-square rounded-full border transition-all cursor-pointer
                          bg-white border-gray-200 text-gray-500
                           peer-checked:text-stone-800 peer-checked:outline-2
                          hover:border-muted hover:bg-muted") do
                lucide_icon(icon)
              end
            end
          end.join.html_safe
        end
      )
    end
  end
end
