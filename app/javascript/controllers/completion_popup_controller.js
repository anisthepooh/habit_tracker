import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.dialogTarget.addEventListener("close", this.enableBodyScroll.bind(this))
    
    // Ensure transition classes are added on connect
    if (!this.dialogTarget.classList.contains('transition-all')) {
      this.dialogTarget.classList.add('transition-all', 'duration-200', 'ease-out')
    }
  }

  disconnect() {
    this.dialogTarget.removeEventListener("close", this.enableBodyScroll.bind(this))
  }

  open() {
    // First, position the dialog off-screen (at the bottom) with scale
    this.dialogTarget.style.transform = ' translateY(100%) scale(0.95)'
    this.dialogTarget.style.opacity = '0'
    
    // Ensure transition classes are present
    if (!this.dialogTarget.classList.contains('transition-all')) {
      this.dialogTarget.classList.add('transition-all', 'duration-200', 'ease-out')
    }
    
    // Show the dialog while it's still off-screen
    this.dialogTarget.showModal()
    this.disableBodyScroll()
    
    // Force a reflow to ensure the initial transform is applied
    void this.dialogTarget.offsetWidth
    
    // Now animate it into view with spring-like easing
    requestAnimationFrame(() => {
      this.dialogTarget.style.transform = ' translateY(50%) scale(1)'
      this.dialogTarget.style.opacity = '1'
    })
  }

  close() {
    this.closeWithAnimation()
  }

  closeWithAnimation() {
    // Ensure transition classes are present
    if (!this.dialogTarget.classList.contains('transition-all')) {
      this.dialogTarget.classList.add('transition-all', 'duration-300', 'ease-in')
    }
    
    // Apply transform to slide out and scale down
    this.dialogTarget.style.transform = ' translateY(100%) scale(0.95)'
    this.dialogTarget.style.opacity = '0'
    
    // Wait for transition to complete before actually closing
    setTimeout(() => {
      this.actualClose()
    }, 300) // Match this to your transition duration
  }

  actualClose() {
    this.dialogTarget.close()
    // Reset transform for next open
    this.dialogTarget.style.transform = ''
    this.dialogTarget.style.opacity = ''
  }

  backdropClose(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  // Disables scrolling on the body
  disableBodyScroll() {
    document.body.classList.add('overflow-hidden')
  }

  // Re-enables scrolling on the body when modal is closed
  enableBodyScroll() {
    document.body.classList.remove('overflow-hidden')
  }
}