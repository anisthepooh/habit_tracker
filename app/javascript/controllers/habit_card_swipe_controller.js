import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "actions"]
  static values = {
    threshold: { type: Number, default: 60 },
    maxReveal: { type: Number, default: 140 }
  }

  connect() {
    this.startX = 0
    this.startY = 0
    this.currentX = 0
    this.currentY = 0
    this.isScrolling = false
    this.isSwiping = false
    this.isRevealed = false
    this.isDragging = false
    
    // Only add touch events if device supports touch
    if ('ontouchstart' in window) {
      this.cardTarget.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: false })
      this.cardTarget.addEventListener('touchmove', this.handleTouchMove.bind(this), { passive: false })
      this.cardTarget.addEventListener('touchend', this.handleTouchEnd.bind(this), { passive: false })
    }
    
    // Add click outside listener to close revealed actions
    document.addEventListener('click', this.handleClickOutside.bind(this))
    
    // Add CSS for smooth hardware-accelerated animations
    this.addAnimationStyles()
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
      
      // Allow both left and right swipes
      if (deltaX < 0) {
        // Left swipe - reveal actions
        const distance = Math.abs(deltaX)
        const maxDistance = Math.min(distance, this.maxRevealValue)
        
        this.cardTarget.style.transform = `translateX(-${maxDistance}px)`
        this.cardTarget.style.transition = 'none'
        
        // Show actions as they're revealed
        if (distance > 20) {
          this.actionsTarget.style.opacity = Math.min(distance / this.thresholdValue, 1)
        }
      } else if (deltaX > 0 && this.isRevealed) {
        // Right swipe - hide actions if already revealed
        const distance = Math.abs(deltaX)
        const remainingTransform = Math.max(this.maxRevealValue - distance, 0)
        
        this.cardTarget.style.transform = `translateX(-${remainingTransform}px)`
        this.cardTarget.style.transition = 'none'
        this.actionsTarget.style.opacity = remainingTransform / this.maxRevealValue
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
      // Left swipe - reveal actions if threshold met
      if (distance > this.thresholdValue) {
        this.revealActions()
      } else {
        this.hideActions()
      }
    } else if (deltaX > 0 && this.isRevealed) {
      // Right swipe on revealed card - hide actions if threshold met
      if (distance > this.thresholdValue / 2) {
        this.hideActions()
      } else {
        this.revealActions() // Snap back to revealed state
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
    if (this.isRevealed && !this.element.contains(event.target)) {
      this.hideActions()
    }
  }

  revealActions() {
    this.isRevealed = true
    this.cardTarget.style.transform = `translateX(-${this.maxRevealValue}px)`
    this.cardTarget.style.transition = 'transform 0.3s ease-out'
    this.actionsTarget.style.opacity = '1'
    
    // Add haptic feedback if available
    if (window.navigator.vibrate) {
      window.navigator.vibrate(50)
    }
  }

  hideActions() {
    this.isRevealed = false
    this.cardTarget.style.transform = 'translateX(0)'
    this.cardTarget.style.transition = 'transform 0.3s ease-out'
    this.actionsTarget.style.opacity = '0'
  }

  resetCard() {
    this.cardTarget.style.transform = 'translateX(0)'
    this.cardTarget.style.transition = 'transform 0.2s ease-out'
    this.actionsTarget.style.opacity = '0'
  }

  closeOtherRevealedCards() {
    // Find all other habit card swipe controllers and close them
    const otherCards = document.querySelectorAll('[data-controller~="habit-card-swipe"]')
    otherCards.forEach(card => {
      if (card !== this.element) {
        const controller = this.application.getControllerForElementAndIdentifier(card, 'habit-card-swipe')
        if (controller && controller.isRevealed) {
          controller.hideActions()
        }
      }
    })
  }

  // Action methods
  edit() {
    // Navigate to edit page
    const editUrl = this.element.dataset.editUrl
    if (editUrl) {
      window.Turbo.visit(editUrl)
    }
  }

  archive() {
    // Archive the habit with optimistic UI
    const archiveUrl = this.element.dataset.archiveUrl
    if (archiveUrl) {
      // Optimistic UI - immediately start animation
      this.element.style.transform = 'translateX(-100%)'
      this.element.style.opacity = '0'
      this.element.style.transition = 'all 0.3s ease-out'
      
      fetch(archiveUrl, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      }).then(response => {
        if (response.ok) {
          // Success - remove element after animation
          setTimeout(() => {
            this.element.remove()
          }, 300)
        } else {
          // Error - revert animation
          this.element.style.transform = 'translateX(0)'
          this.element.style.opacity = '1'
          alert('Failed to archive habit. Please try again.')
        }
      }).catch(() => {
        // Error - revert animation
        this.element.style.transform = 'translateX(0)'
        this.element.style.opacity = '1'
        alert('Failed to archive habit. Please try again.')
      })
    }
  }

  delete() {
    // Delete the habit with confirmation
    if (confirm('Are you sure you want to delete this habit?')) {
      const deleteUrl = this.element.dataset.deleteUrl
      if (deleteUrl) {
        // Optimistic UI - immediately start animation
        this.element.style.transform = 'translateX(-100%)'
        this.element.style.opacity = '0'
        this.element.style.transition = 'all 0.3s ease-out'
        
        fetch(deleteUrl, {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            'Accept': 'application/json'
          }
        }).then(response => {
          if (response.ok) {
            // Success - remove element after animation
            setTimeout(() => {
              this.element.remove()
            }, 300)
          } else {
            // Error - revert animation
            this.element.style.transform = 'translateX(0)'
            this.element.style.opacity = '1'
            alert('Failed to delete habit. Please try again.')
          }
        }).catch(() => {
          // Error - revert animation
          this.element.style.transform = 'translateX(0)'
          this.element.style.opacity = '1'
          alert('Failed to delete habit. Please try again.')
        })
      }
    }
  }

  addAnimationStyles() {
    // Add CSS for smooth animations if not already added
    if (!document.querySelector('#habit-card-swipe-styles')) {
      const style = document.createElement('style')
      style.id = 'habit-card-swipe-styles'
      style.textContent = `
        [data-controller~="habit-card-swipe"] {
          will-change: transform;
        }
        
        [data-habit-card-swipe-target="card"] {
          will-change: transform;
          backface-visibility: hidden;
          -webkit-backface-visibility: hidden;
        }
        
        [data-habit-card-swipe-target="actions"] {
          will-change: opacity;
          backface-visibility: hidden;
          -webkit-backface-visibility: hidden;
        }
        
        /* Smooth action button hover effects */
        [data-habit-card-swipe-target="actions"] button {
          transition: all 0.2s ease;
        }
        
        [data-habit-card-swipe-target="actions"] button:active {
          transform: scale(0.95);
        }
        
        /* Reduce motion for users who prefer it */
        @media (prefers-reduced-motion: reduce) {
          [data-habit-card-swipe-target="card"],
          [data-habit-card-swipe-target="actions"],
          [data-habit-card-swipe-target="actions"] button {
            transition: none !important;
          }
        }
      `
      document.head.appendChild(style)
    }
  }
}