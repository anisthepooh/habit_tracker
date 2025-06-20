import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "settings"]

  connect() {
    // Initialize visibility based on toggle state
    this.toggleReminderSettings()
  }

  toggleReminderSettings() {
    const isEnabled = this.toggleTarget.checked
    
    if (isEnabled) {
      this.settingsTarget.classList.remove('hidden')
      this.settingsTarget.classList.add('animate-fadeIn')
    } else {
      this.settingsTarget.classList.add('hidden')
      this.settingsTarget.classList.remove('animate-fadeIn')
    }
  }
}