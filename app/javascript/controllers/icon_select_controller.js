import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
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
  }
}
