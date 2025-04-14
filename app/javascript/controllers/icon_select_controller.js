import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"] // Add the button target
  static values = { icon: String }

  select(event) {
    const icon = event.currentTarget.dataset.iconSelectIconValue
    this.inputTarget.value = icon

    // Remove selection state from others
    this.element.querySelectorAll("button").forEach(btn =>
      btn.classList.remove("border-blue-500", "bg-primary", "text-primary-foreground")
    )

    // Highlight selected
    event.currentTarget.classList.add("border-blue-500", "bg-primary", "text-primary-foreground")
    const button = document.getElementById("preview-icon-button")
    // Update button icon outside modal if target exists
    console.log(icon)
    if (button) {
      button.innerHTML = this.getIcon(icon)
    }
  }

  getIcon(icon) {
    // Assuming lucide icons are globally available or inline rendered
    return `<svg class="lucide w-16 h-16"><use href="#lucide-${icon}"></use></svg>`
  }
}
