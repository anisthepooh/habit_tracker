// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wrapper"]

  connect() {
    setTimeout(() => {
      this.wrapperTarget.classList.remove("animate-fade-in")
      this.wrapperTarget.classList.add("animate-fade-out")

      setTimeout(() => this.wrapperTarget.remove(), 500)
    }, 3000)
  }
}
