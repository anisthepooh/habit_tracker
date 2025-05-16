import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "main"]

  connect() {
    this.isCollapsed = false
  }

  toggle() {
    this.isCollapsed = !this.isCollapsed

    if (this.isCollapsed) {
      this.sidebarTarget.classList.add("opacity-0")

      setTimeout(() => {
        this.sidebarTarget.classList.add("-translate-x-full", "!w-0", "!pl-0")
        this.mainTarget.classList.add("!pl-0")
      }, 300)
    } else {
      this.sidebarTarget.classList.remove("invisible", "!w-0", "!pl-0")
      this.sidebarTarget.classList.remove("-translate-x-full")

      setTimeout(() => {
        this.sidebarTarget.classList.remove( "opacity-0")
      }, 200)

      this.mainTarget.classList.remove("!pl-0")
    }
  }
}
