import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "main"]

  connect() {
    // Check if mobile view (< 768px)
    this.isMobile = window.innerWidth < 768
    
    // Get saved state from localStorage or default to expanded
    const savedState = localStorage.getItem('admin-sidebar-collapsed')
    let isCollapsed
    
    if (savedState !== null) {
      isCollapsed = savedState === 'true'
    } else {
      // Default: expanded on both mobile and desktop
      isCollapsed = false
    }
    
    this.isCollapsed = isCollapsed
    
    // Remove FOUC prevention attributes since Stimulus is now in control
    document.body.removeAttribute('data-sidebar-collapsed')
    document.body.removeAttribute('data-sidebar-initialized')
    
    this.applySidebarState(false) // false = no animation on initial load
    
    // Listen for window resize to handle mobile/desktop transitions
    this.handleResize = this.handleResize.bind(this)
    window.addEventListener('resize', this.handleResize)
  }

  disconnect() {
    window.removeEventListener('resize', this.handleResize)
    this.removeBackdrop()
  }

  toggle() {
    this.isCollapsed = !this.isCollapsed
    this.applySidebarState(true) // true = with animation
    
    // Save state to localStorage
    localStorage.setItem('admin-sidebar-collapsed', this.isCollapsed.toString())
  }

  applySidebarState(animate = true) {
    if (this.isCollapsed) {
      this.collapseSidebar(animate)
    } else {
      this.expandSidebar(animate)
    }
  }

  collapseSidebar(animate = true) {
    this.removeBackdrop() // Remove backdrop immediately
    
    if (animate) {
      this.sidebarTarget.classList.add("opacity-0")
      setTimeout(() => {
        this.sidebarTarget.classList.add("-translate-x-full")
        this.sidebarTarget.classList.remove("w-64", "pl-6")
        this.sidebarTarget.style.width = "0"
        this.sidebarTarget.style.paddingLeft = "0"
      }, 150)
    } else {
      this.sidebarTarget.classList.add("opacity-0", "-translate-x-full")
      this.sidebarTarget.classList.remove("w-64", "pl-6")
      this.sidebarTarget.style.width = "0"
      this.sidebarTarget.style.paddingLeft = "0"
    }
  }

  expandSidebar(animate = true) {
    // Remove collapse classes
    this.sidebarTarget.classList.remove("invisible", "-translate-x-full", "opacity-0")
    
    // Same behavior for both mobile and desktop - no overlay
    this.sidebarTarget.style.cssText = ""
    
    // Ensure original classes are restored
    if (!this.sidebarTarget.classList.contains("w-64")) {
      this.sidebarTarget.classList.add("w-64")
    }
    if (!this.sidebarTarget.classList.contains("pl-6")) {
      this.sidebarTarget.classList.add("pl-6")
    }
  }

  handleResize() {
    const wasMobile = this.isMobile
    this.isMobile = window.innerWidth < 768
    
    // If transitioning from mobile to desktop, check saved preference
    if (wasMobile && !this.isMobile) {
      const savedState = localStorage.getItem('admin-sidebar-collapsed')
      if (savedState !== null) {
        this.isCollapsed = savedState === 'true'
      } else {
        this.isCollapsed = false // Default expanded on desktop
      }
      this.applySidebarState(false)
    }
    // If transitioning from desktop to mobile, keep current state
    else if (!wasMobile && this.isMobile) {
      // Don't force collapse on mobile - keep current state
      this.applySidebarState(false)
    }
  }

  createBackdrop() {
    if (this.backdrop) return // Already exists
    
    this.backdrop = document.createElement('div')
    this.backdrop.style.cssText = 'position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0, 0, 0, 0.3); z-index: 1000;'
    this.backdrop.addEventListener('click', () => {
      this.toggle()
    })
    document.body.appendChild(this.backdrop)
  }

  removeBackdrop() {
    if (this.backdrop) {
      this.backdrop.remove()
      this.backdrop = null
    }
  }
}
