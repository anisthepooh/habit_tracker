// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  switch(event) {
    const selectedId = event.currentTarget.dataset.id

    // Toggle tab button state
    this.tabTargets.forEach(tab => {
      tab.dataset.active = tab.dataset.id === selectedId
    })

    // Toggle visible content
    this.contentTargets.forEach(content => {
      content.classList.toggle("hidden", content.dataset.id !== selectedId)
    })
  }
}
