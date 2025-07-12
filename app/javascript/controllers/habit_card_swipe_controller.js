import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "actions"]
  static values = {
    snapPoint: { type: Number, default: 80 },
    triggerThreshold: { type: Number, default: 120 },
    leftAction: { type: String, default: "" }
  }

  connect() {
    this.startX = 0
    this.startY = 0
    this.currentX = 0
    this.currentY = 0
    this.isScrolling = false
    this.isSwiping = false
    this.isAtSnapPoint = false
    this.isDragging = false
    
    // Only add touch events if device supports touch
    if ('ontouchstart' in window) {
      this.cardTarget.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: false })
      this.cardTarget.addEventListener('touchmove', this.handleTouchMove.bind(this), { passive: false })
      this.cardTarget.addEventListener('touchend', this.handleTouchEnd.bind(this), { passive: false })
    }
    
    // Add click outside listener to close revealed actions
    document.addEventListener('click', this.handleClickOutside.bind(this))
    
  }

  disconnect() {
    this.cardTarget.removeEventListener('touchstart', this.handleTouchStart)
    this.cardTarget.removeEventListener('touchmove', this.handleTouchMove)
    this.cardTarget.removeEventListener('touchend', this.handleTouchEnd)
    document.removeEventListener('click', this.handleClickOutside)
  }

  handleTouchStart(event) {
    this.startX = event.touches[0].clientX
    this.startY = event.touches[0].clientY
    this.isScrolling = false
    this.isSwiping = false
    this.isDragging = false
    
    // Stop event from bubbling to page-level swipe navigation
    event.stopPropagation()
    
    // Close other revealed cards
    this.closeOtherRevealedCards()
  }

  handleTouchMove(event) {
    if (!this.startX || !this.startY) return

    this.currentX = event.touches[0].clientX
    this.currentY = event.touches[0].clientY

    const deltaX = this.currentX - this.startX
    const deltaY = this.currentY - this.startY

    // Determine if this is a vertical scroll or horizontal swipe
    if (!this.isScrolling && !this.isSwiping) {
      if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 10) {
        this.isSwiping = true
        this.isDragging = true
        event.preventDefault() // Prevent scrolling during swipe
        event.stopPropagation() // Prevent page-level swipe navigation
      } else if (Math.abs(deltaY) > 10) {
        this.isScrolling = true
        // Allow vertical scrolling, don't prevent or stop propagation
        return
      }
    }

    // Always stop propagation during horizontal swipes to prevent page navigation
    if (this.isSwiping) {
      event.preventDefault()
      event.stopPropagation()
      
      // iOS-style swipe with stretching
      if (deltaX < 0) {
        // Left swipe - reveal and stretch actions
        const distance = Math.abs(deltaX)
        
        if (distance <= this.snapPointValue) {
          // Normal reveal up to snap point
          this.cardTarget.style.transform = `translateX(-${distance}px)`
          this.actionsTarget.style.width = `${distance}px`
          this.actionsTarget.style.opacity = Math.min(distance / this.snapPointValue, 1)
        } else {
          // Beyond snap point - stretch the action button
          const stretchDistance = distance - this.snapPointValue
          const actionWidth = this.snapPointValue + (stretchDistance * 0.5) // Stretch slower
          
          this.cardTarget.style.transform = `translateX(-${distance}px)`
          this.actionsTarget.style.width = `${actionWidth}px`
          this.actionsTarget.style.opacity = '1'
          
          // Update the button inside to fill the space and add visual feedback
          const actionButton = this.actionsTarget.querySelector('a')
          if (actionButton) {
            actionButton.style.width = '100%'
            actionButton.style.minWidth = `${actionWidth}px`
            
            // Add visual feedback when approaching trigger threshold
            if (distance > this.triggerThresholdValue * 0.8) {
              actionButton.style.backgroundColor = 'black' // Green when close to trigger
            } else {
              actionButton.style.backgroundColor = '' // Reset to default
            }
          }
        }
        
        this.cardTarget.style.transition = 'none'
        this.actionsTarget.style.transition = 'none'
        
      } else if (deltaX > 0 && this.isAtSnapPoint) {
        // Right swipe - hide actions if at snap point
        const distance = Math.abs(deltaX)
        const remainingTransform = Math.max(this.snapPointValue - distance, 0)
        
        this.cardTarget.style.transform = `translateX(-${remainingTransform}px)`
        this.actionsTarget.style.width = `${remainingTransform}px`
        this.actionsTarget.style.opacity = remainingTransform / this.snapPointValue
        this.cardTarget.style.transition = 'none'
        this.actionsTarget.style.transition = 'none'
      }
    }
  }

  handleTouchEnd(event) {
    if (!this.startX || !this.startY || !this.isSwiping) {
      this.resetCard()
      return
    }

    // Stop propagation to prevent page-level navigation
    event.stopPropagation()

    const deltaX = this.currentX - this.startX
    const distance = Math.abs(deltaX)

    if (deltaX < 0) {
      // Left swipe - check for trigger threshold first
      if (distance > this.triggerThresholdValue && this.leftActionValue) {
        this.triggerLeftAction()
      } else if (distance > this.snapPointValue / 2) {
        this.snapToRevealedState()
      } else {
        this.hideActions()
      }
    } else if (deltaX > 0 && this.isAtSnapPoint) {
      // Right swipe on revealed card - hide if threshold met
      if (distance > this.snapPointValue / 3) {
        this.hideActions()
      } else {
        this.snapToRevealedState() // Snap back to revealed state
      }
    } else {
      this.hideActions()
    }

    this.startX = 0
    this.startY = 0
    this.currentX = 0
    this.currentY = 0
    this.isScrolling = false
    this.isSwiping = false
    this.isDragging = false
  }

  handleClickOutside(event) {
    // Close actions if clicking outside this card
    if (this.isAtSnapPoint && !this.element.contains(event.target)) {
      this.hideActions()
    }
  }

  snapToRevealedState() {
    this.isAtSnapPoint = true
    this.cardTarget.style.transform = `translateX(-${this.snapPointValue}px)`
    this.cardTarget.style.transition = 'transform 0.3s cubic-bezier(0.2, 0.8, 0.2, 1)'
    this.actionsTarget.style.width = `${this.snapPointValue}px`
    this.actionsTarget.style.opacity = '1'
    this.actionsTarget.style.transition = 'width 0.3s cubic-bezier(0.2, 0.8, 0.2, 1)'
    
    // Reset button styles
    const actionButton = this.actionsTarget.querySelector('a')
    if (actionButton) {
      actionButton.style.width = '100%'
      actionButton.style.minWidth = `${this.snapPointValue}px`
      actionButton.style.backgroundColor = '' // Reset color
    }
    
    // Add haptic feedback if available
    if (window.navigator.vibrate) {
      window.navigator.vibrate(50)
    }
  }

  hideActions() {
    this.isAtSnapPoint = false
    this.cardTarget.style.transform = 'translateX(0)'
    this.cardTarget.style.transition = 'transform 0.3s cubic-bezier(0.2, 0.8, 0.2, 1)'
    this.actionsTarget.style.width = '0px'
    this.actionsTarget.style.opacity = '0'
    this.actionsTarget.style.transition = 'width 0.3s cubic-bezier(0.2, 0.8, 0.2, 1)'
    
    // Reset button styles
    const actionButton = this.actionsTarget.querySelector('a')
    if (actionButton) {
      actionButton.style.width = '100%'
      actionButton.style.minWidth = '80px'
      actionButton.style.backgroundColor = '' // Reset color
    }
  }

  resetCard() {
    this.cardTarget.style.transform = 'translateX(0)'
    this.cardTarget.style.transition = 'transform 0.2s ease-out'
    this.actionsTarget.style.width = '0px'
    this.actionsTarget.style.opacity = '0'
    
    // Reset button styles
    const actionButton = this.actionsTarget.querySelector('a')
    if (actionButton) {
      actionButton.style.width = '100%'
      actionButton.style.minWidth = '80px'
      actionButton.style.backgroundColor = '' // Reset color
    }
  }

  closeOtherRevealedCards() {
    // Find all other habit card swipe controllers and close them
    const otherCards = document.querySelectorAll('[data-controller~="habit-card-swipe"]')
    otherCards.forEach(card => {
      if (card !== this.element) {
        const controller = this.application.getControllerForElementAndIdentifier(card, 'habit-card-swipe')
        if (controller && controller.isAtSnapPoint) {
          controller.hideActions()
        }
      }
    })
  }

  triggerLeftAction() {
    // Hide actions and trigger the specified action
    this.hideActions()
    
    // Add stronger haptic feedback for full swipe
    if (window.navigator.vibrate) {
      window.navigator.vibrate([50, 50, 50])
    }
    
    // Find and click the existing action button instead of creating a new one
    if (this.leftActionValue) {
      const actionButton = this.actionsTarget.querySelector(`a[href="${this.leftActionValue}"]`)
      if (actionButton) {
        actionButton.click()
      }
    }
  }
}