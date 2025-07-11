import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    leftUrl: String,
    rightUrl: String,
    threshold: { type: Number, default: 80 },
    velocity: { type: Number, default: 0.3 }
  }

  connect() {
    this.startX = 0
    this.startY = 0
    this.currentX = 0
    this.currentY = 0
    this.isScrolling = false
    this.isSwiping = false
    
    // Only add touch events if device supports touch
    if ('ontouchstart' in window) {
      this.element.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: false })
      this.element.addEventListener('touchmove', this.handleTouchMove.bind(this), { passive: false })
      this.element.addEventListener('touchend', this.handleTouchEnd.bind(this), { passive: false })
      
      // Add subtle visual indicators only for touch devices
      this.addSwipeIndicators()
    }
    
    // Add keyboard navigation support
    this.element.addEventListener('keydown', this.handleKeyDown.bind(this))
    
    // Ensure element is focusable for keyboard navigation
    if (!this.element.hasAttribute('tabindex')) {
      this.element.setAttribute('tabindex', '0')
    }
  }

  disconnect() {
    this.element.removeEventListener('touchstart', this.handleTouchStart)
    this.element.removeEventListener('touchmove', this.handleTouchMove)
    this.element.removeEventListener('touchend', this.handleTouchEnd)
    this.element.removeEventListener('keydown', this.handleKeyDown)
  }

  handleTouchStart(event) {
    this.startX = event.touches[0].clientX
    this.startY = event.touches[0].clientY
    this.isScrolling = false
    this.isSwiping = false
  }

  handleTouchMove(event) {
    if (!this.startX || !this.startY) return

    this.currentX = event.touches[0].clientX
    this.currentY = event.touches[0].clientY

    const deltaX = this.currentX - this.startX
    const deltaY = this.currentY - this.startY

    // Determine if this is a vertical scroll or horizontal swipe
    if (!this.isScrolling && !this.isSwiping) {
      if (Math.abs(deltaX) > Math.abs(deltaY)) {
        this.isSwiping = true
        event.preventDefault() // Prevent scrolling during swipe
      } else {
        this.isScrolling = true
      }
    }

    // If we're swiping, provide visual feedback
    if (this.isSwiping && Math.abs(deltaX) > 10) {
      const maxTranslate = 20
      const progress = Math.min(Math.abs(deltaX) / this.thresholdValue, 1)
      const translateX = (deltaX > 0 ? 1 : -1) * progress * maxTranslate
      
      this.element.style.transform = `translateX(${translateX}px)`
      this.element.style.transition = 'none'
    }
  }

  handleTouchEnd() {
    if (!this.startX || !this.startY || !this.isSwiping) {
      this.resetTransform()
      return
    }

    const deltaX = this.currentX - this.startX
    const deltaY = this.currentY - this.startY
    const distance = Math.abs(deltaX)
    const isHorizontal = Math.abs(deltaX) > Math.abs(deltaY)

    if (isHorizontal && distance > this.thresholdValue) {
      if (deltaX > 0) {
        // Swipe right
        this.handleSwipeRight()
      } else {
        // Swipe left
        this.handleSwipeLeft()
      }
    } else {
      // Add haptic feedback for partial swipes (if available)
      if (window.navigator.vibrate && distance > 20) {
        window.navigator.vibrate(50)
      }
      this.resetTransform()
    }

    this.startX = 0
    this.startY = 0
    this.currentX = 0
    this.currentY = 0
    this.isScrolling = false
    this.isSwiping = false
  }

  handleSwipeLeft() {
    if (this.leftUrlValue) {
      this.navigate(this.leftUrlValue, 'left')
    } else {
      this.resetTransform()
    }
  }

  handleSwipeRight() {
    if (this.rightUrlValue) {
      this.navigate(this.rightUrlValue, 'right')
    } else {
      this.resetTransform()
    }
  }

  handleKeyDown(event) {
    // Support keyboard navigation with arrow keys
    if (event.key === 'ArrowLeft' && this.leftUrlValue) {
      event.preventDefault()
      this.navigate(this.leftUrlValue, 'left')
    } else if (event.key === 'ArrowRight' && this.rightUrlValue) {
      event.preventDefault()
      this.navigate(this.rightUrlValue, 'right')
    }
  }

  navigate(url, direction) {
    // Enhanced visual feedback
    this.element.style.transform = `translateX(${direction === 'left' ? '-30px' : '30px'})`
    this.element.style.transition = 'transform 0.2s ease-out'
    this.element.style.opacity = '0.8'
    
    // Navigate after brief visual feedback
    setTimeout(() => {
      window.Turbo.visit(url)
    }, 200)
  }

  resetTransform() {
    this.element.style.transform = ''
    this.element.style.transition = 'transform 0.2s ease-out'
    this.element.style.opacity = ''
    
    // Clean up styles after transition
    setTimeout(() => {
      this.element.style.transition = ''
    }, 200)
  }

  addSwipeIndicators() {
    // Add subtle CSS class to indicate swipe availability
    this.element.classList.add('swipe-enabled')
    
    // Add ARIA attributes for accessibility
    this.element.setAttribute('aria-label', 'Swipe left or right to navigate, or use arrow keys')
    this.element.setAttribute('role', 'region')
    
    // Add CSS for swipe indicators
    if (!document.querySelector('#swipe-navigation-styles')) {
      const style = document.createElement('style')
      style.id = 'swipe-navigation-styles'
      style.textContent = `
        .swipe-enabled {
          position: relative;
          overflow: hidden;
        }
        
        .swipe-enabled::before,
        .swipe-enabled::after {
          content: '';
          position: absolute;
          top: 50%;
          width: 2px;
          height: 20px;
          background: rgba(156, 163, 175, 0.3);
          border-radius: 1px;
          transform: translateY(-50%);
          opacity: 0;
          transition: opacity 0.3s ease;
          z-index: 1;
        }
        
        .swipe-enabled::before {
          left: 4px;
        }
        
        .swipe-enabled::after {
          right: 4px;
        }
        
        .swipe-enabled:hover::before,
        .swipe-enabled:hover::after,
        .swipe-enabled:focus::before,
        .swipe-enabled:focus::after {
          opacity: 1;
        }
        
        
        @media (hover: none) {
          .swipe-enabled::before,
          .swipe-enabled::after {
            opacity: 0.5;
          }
        }
        
        /* Reduce motion for users who prefer it */
        @media (prefers-reduced-motion: reduce) {
          .swipe-enabled,
          .swipe-enabled * {
            transition: none !important;
          }
        }
      `
      document.head.appendChild(style)
    }
  }
}