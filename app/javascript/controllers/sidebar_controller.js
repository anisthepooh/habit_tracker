import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "main"]

  connect() {
    // Check if mobile view (< 768px)
    this.isMobile = window.innerWidth < 768
    
    // Get saved state from localStorage or default based on screen size
    const savedState = localStorage.getItem('admin-sidebar-collapsed')
    let isCollapsed
    
    if (savedState !== null) {
      isCollapsed = savedState === 'true'
    } else {
      // Default: collapsed on mobile, expanded on desktop
      isCollapsed = this.isMobile
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
    if (animate) {
      this.sidebarTarget.classList.add("opacity-0")
      setTimeout(() => {
        this.sidebarTarget.classList.add("-translate-x-full", "!w-0", "!pl-0")
        this.mainTarget.classList.add("!pl-0")
      }, 300)
    } else {
      this.sidebarTarget.classList.add("opacity-0", "-translate-x-full", "!w-0", "!pl-0")
      this.mainTarget.classList.add("!pl-0")
    }
  }

  expandSidebar(animate = true) {
    this.sidebarTarget.classList.remove("invisible", "!w-0", "!pl-0")
    this.sidebarTarget.classList.remove("-translate-x-full")
    this.mainTarget.classList.remove("!pl-0")

    if (animate) {
      setTimeout(() => {
        this.sidebarTarget.classList.remove("opacity-0")
      }, 200)
    } else {
      this.sidebarTarget.classList.remove("opacity-0")
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
    // If transitioning from desktop to mobile, always collapse
    else if (!wasMobile && this.isMobile) {
      this.isCollapsed = true
      this.applySidebarState(false)
    }
  }
}
