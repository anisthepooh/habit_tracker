import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

export default class Dropdown extends Controller {
  static targets = ["menu", "button"]

  connect() {
    useTransition(this, {
      element: this.menuTarget,
    })
  }

  toggle() {
    this.toggleTransition()
    this.buttonTarget.classList.toggle("bg-gray-100")
  }

  hide(event) {
    // @ts-expect-error
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains("hidden")) {
      this.leave()
      this.buttonTarget.classList.remove("bg-gray-100")
    }
  }
}