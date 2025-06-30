import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "display"]
  
  connect() {
    if (this.isIOS()) {
      this.setupIOSSelect()
    }
  }
  
  isIOS() {
    return /iPad|iPhone|iPod/.test(navigator.userAgent) || 
           (navigator.userAgentData?.platform === 'macOS' && navigator.maxTouchPoints > 1)
  }
  
  setupIOSSelect() {
    if (this.hasSelectTarget) {
      this.selectTarget.addEventListener('change', this.updateDisplay.bind(this))
      this.selectTarget.addEventListener('focus', this.handleFocus.bind(this))
      this.selectTarget.addEventListener('blur', this.handleBlur.bind(this))
    }
  }
  
  updateDisplay(event) {
    if (!this.hasDisplayTarget) return
    
    const selectedOption = event.target.selectedOptions[0]
    if (selectedOption) {
      // Update the display to show the selected value
      const displayContent = this.displayTarget.querySelector('[data-ios-select-content]')
      if (displayContent) {
        displayContent.textContent = selectedOption.textContent
      }
    }
  }
  
  handleFocus() {
    // Add focus styles or behaviors if needed
    this.displayTarget?.classList.add('ios-select-focused')
  }
  
  handleBlur() {
    // Remove focus styles
    this.displayTarget?.classList.remove('ios-select-focused')
  }
}