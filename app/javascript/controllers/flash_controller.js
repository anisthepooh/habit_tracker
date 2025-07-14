// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wrapper"]

  connect() {
    this.startY = 0
    this.currentY = 0
    this.isDragging = false
    this.startTime = 0
    this.dismissThreshold = 50 // pixels
    this.velocityThreshold = 0.5 // pixels per ms
    
    // Get delay from data attribute, default to 0
    const delay = parseInt(this.data.get('delay') || '0')
    
    // Add touch event listeners
    this.wrapperTarget.addEventListener('touchstart', this.handleTouchStart.bind(this))
    this.wrapperTarget.addEventListener('touchmove', this.handleTouchMove.bind(this))
    this.wrapperTarget.addEventListener('touchend', this.handleTouchEnd.bind(this))
    
    // Show flash after delay
    setTimeout(() => {
      this.show()
    }, delay)
    
    // Auto-dismiss after 4 seconds (increased from 3 for better UX)
    this.autoDismissTimer = setTimeout(() => {
      this.dismiss()
    }, 4000 + delay)
  }

  show() {
    this.wrapperTarget.style.opacity = '1'
    this.wrapperTarget.style.transform = 'translateY(0)'
  }

  disconnect() {
    if (this.autoDismissTimer) {
      clearTimeout(this.autoDismissTimer)
    }
  }

  handleTouchStart(event) {
    this.startY = event.touches[0].clientY
    this.currentY = this.startY
    this.isDragging = true
    this.startTime = Date.now()
    
    // Cancel auto-dismiss when user starts interacting
    if (this.autoDismissTimer) {
      clearTimeout(this.autoDismissTimer)
      this.autoDismissTimer = null
    }
    
    // Add active state
    this.wrapperTarget.style.transition = 'none'
  }

  handleTouchMove(event) {
    if (!this.isDragging) return
    
    event.preventDefault()
    this.currentY = event.touches[0].clientY
    const deltaY = this.currentY - this.startY
    
    // Only allow upward swipes
    if (deltaY < 0) {
      // More responsive following - direct 1:1 movement
      const translateY = deltaY
      // Smoother opacity transition based on distance
      const opacity = Math.max(0.1, 1 + (deltaY / 150))
      // Add slight scale effect for more natural feel
      const scale = Math.max(0.95, 1 + (deltaY / 300))
      
      this.wrapperTarget.style.transform = `translateY(${translateY}px) scale(${scale})`
      this.wrapperTarget.style.opacity = opacity
    }
  }

  handleTouchEnd(event) {
    if (!this.isDragging) return
    
    this.isDragging = false
    const deltaY = this.currentY - this.startY
    const duration = Date.now() - this.startTime
    const velocity = Math.abs(deltaY) / duration
    
    // Determine if should dismiss based on distance or velocity
    const shouldDismiss = (deltaY < -this.dismissThreshold) || 
                         (deltaY < 0 && velocity > this.velocityThreshold)
    
    if (shouldDismiss) {
      this.dismissWithMomentum(deltaY, velocity)
    } else {
      // Restore original position with bounce-back animation
      this.wrapperTarget.style.transition = 'all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)'
      this.wrapperTarget.style.transform = 'translateY(0) scale(1)'
      this.wrapperTarget.style.opacity = '1'
      
      // Resume auto-dismiss timer
      this.autoDismissTimer = setTimeout(() => {
        this.dismiss()
      }, 2000)
    }
  }

  dismissWithMomentum(deltaY, velocity) {
    // Cancel any pending auto-dismiss
    if (this.autoDismissTimer) {
      clearTimeout(this.autoDismissTimer)
      this.autoDismissTimer = null
    }
    
    // Calculate final position based on current position and velocity
    const finalY = Math.min(deltaY - (velocity * 200), -150)
    
    // Use momentum-based animation that feels natural
    this.wrapperTarget.style.transition = 'all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94)'
    this.wrapperTarget.style.transform = `translateY(${finalY}px) scale(0.9)`
    this.wrapperTarget.style.opacity = '0'
    
    setTimeout(() => {
      if (this.wrapperTarget && this.wrapperTarget.parentNode) {
        this.wrapperTarget.remove()
      }
    }, 400)
  }

  dismiss() {
    // Cancel any pending auto-dismiss
    if (this.autoDismissTimer) {
      clearTimeout(this.autoDismissTimer)
      this.autoDismissTimer = null
    }
    
    // Standard dismiss animation (for auto-dismiss)
    this.wrapperTarget.style.transition = 'all 0.5s ease-in-out'
    this.wrapperTarget.style.transform = 'translateY(-100px) scale(0.95)'
    this.wrapperTarget.style.opacity = '0'
    
    setTimeout(() => {
      if (this.wrapperTarget && this.wrapperTarget.parentNode) {
        this.wrapperTarget.remove()
      }
    }, 500)
  }
}
