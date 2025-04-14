import { Controller } from "@hotwired/stimulus"
import { enter, leave } from 'el-transition'

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.dialogTarget.addEventListener("close", this.enableBodyScroll.bind(this))
  }

  disconnect() {
    this.dialogTarget.removeEventListener("close", this.enableBodyScroll.bind(this))
  }

  open() {
    this.disableBodyScroll()
    this.dialogTarget.showModal()

    // Trigger the enter transition using data attributes
    enter(this.dialogTarget)
      .then(() => {
        console.log("Modal entered with transition!")
      })
  }

  close() {
    // Trigger the leave transition using data attributes
    leave(this.dialogTarget)
      .then(() => {
        console.log("Modal left with transition!")
      })
    this.dialogTarget.close()
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
