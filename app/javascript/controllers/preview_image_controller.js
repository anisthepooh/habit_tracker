// preview_image_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "image", "removeField"]

  update() {
    const file = this.inputTarget.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        this.imageTarget.src = e.target.result
        this.imageTarget.classList.remove("hidden")
      }
      reader.readAsDataURL(file)
    }
  }

  remove() {
    this.imageTarget.src = ""
    this.removeFieldTarget.value = true
  }
}
