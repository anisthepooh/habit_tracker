import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["modal", "frame", "content"]
  
  // Track fixed elements to restore them later
  fixedElements = []

  connect() {
    this.modalTarget.addEventListener("close", this.enableBodyScroll.bind(this))
    
    // Ensure transition classes are added on connect
    if (!this.modalTarget.classList.contains('transition-transform')) {
      this.modalTarget.classList.add('transition-transform', 'duration-300')
    }
  }

  disconnect() {
    this.modalTarget.removeEventListener("close", this.enableBodyScroll.bind(this))
  }

  // hide modal on successful form submission
  submitEnd(e) {
    if (e.detail.success) {
      this.closeWithAnimation()
    }
  }

  open() {
    
    // First, position the dialog off-screen (at the bottom)
    this.modalTarget.style.transform = 'translateY(100%)'
    this.contentTarget.classList.add("overflow-hidden")
    
    // Ensure transition classes are present
    if (!this.modalTarget.classList.contains('transition-transform')) {
      this.modalTarget.classList.add('transition-transform', 'duration-300')
    }
    
    // Show the dialog while it's still off-screen
    this.modalTarget.showModal()
    document.body.classList.add('overflow-hidden')
    document.body.classList.add('dialog-open')
    
    // Force a reflow to ensure the initial transform is applied
    void this.modalTarget.offsetWidth
    
    // Now animate it into view
    requestAnimationFrame(() => {
      this.modalTarget.style.transform = 'translateY(0)'
    })
  }

  closeWithAnimation() {
    // Ensure transition classes are present
    if (!this.modalTarget.classList.contains('transition-transform')) {
      this.modalTarget.classList.add('transition-transform', 'duration-300')
    }
    
    // Apply transform to slide out
    this.modalTarget.style.transform = 'translateY(100%)'
    this.contentTarget.classList.remove("overflow-hidden")
    
    // Remove dialog-open class to revert scale effect
    document.body.classList.remove('dialog-open')
    
    
    // Wait for transition to complete before actually closing
    setTimeout(() => {
      this.actualClose()
    }, 300) // Match this to your transition duration
  }

  actualClose() {
    this.modalTarget.close()
    this.frameTarget.removeAttribute("src")
    this.frameTarget.innerHTML = ""
  }
  
  close() {
    this.closeWithAnimation()
  }

  enableBodyScroll() {
    document.body.classList.remove('overflow-hidden')
    document.body.classList.remove('dialog-open')
    

  }

  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.closeWithAnimation()
    }
  }
  

}