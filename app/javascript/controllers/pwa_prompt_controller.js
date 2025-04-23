import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wrapper"]

  installPromptEvent = null

  connect() {
    if (this.shouldShowPrompt()) {
      this.wrapperTarget.classList.remove("hidden")
      window.addEventListener("beforeinstallprompt", this.handleBeforeInstallPrompt)
      window.addEventListener("appinstalled", this.disablePrompt)

      requestAnimationFrame(() => {
        this.wrapperTarget.classList.remove("-translate-y-full")
        this.wrapperTarget.classList.add("translate-y-0")
      })
    } else {
      this.wrapperTarget.remove()
    }
  }

  disconnect() {
    window.removeEventListener("beforeinstallprompt", this.handleBeforeInstallPrompt)
    window.removeEventListener("appinstalled", this.disablePrompt)
  }

  handleBeforeInstallPrompt = (event) => {
    event.preventDefault()
    this.installPromptEvent = event
  }

  async triggerInstall() {
    if (!this.installPromptEvent) return

    const result = await this.installPromptEvent.prompt()
    console.log("User response:", result.outcome)

    this.installPromptEvent = null
    this.disablePrompt()
  }

  close() {
    this.wrapperTarget.classList.remove("translate-y-0")
    this.wrapperTarget.classList.add("-translate-y-full")

    setTimeout(() => {
      this.wrapperTarget.remove()
    }, 500)

      localStorage.setItem("pwaPromptDismissed", "true")
  }

  disablePrompt = () => {
    this.installPromptEvent = null
    this.close()
  }

  shouldShowPrompt() {
    const dismissed = window.localStorage.getItem("pwaPromptDismissed")

    const isStandalone = window.matchMedia("(display-mode: standalone)").matches || window.navigator.standalone

    return !isStandalone && !dismissed
  }
}
