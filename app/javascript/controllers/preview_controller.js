import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["preview"]
  static values = { iconSvgs: Object }

  update(event) {
    const iconName = event.target.value
    const svg = this.iconSvgsValue[iconName]
    if (svg) {
      this.previewTarget.innerHTML = svg
    }
  }
}

