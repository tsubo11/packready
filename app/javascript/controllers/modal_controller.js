import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "panel"]

  open(event) {
    const timing = event.currentTarget.dataset.timing
    this.overlayTarget.dataset.timing = timing
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
  }

  clickOutside(event) {
    if (!this.panelTarget.contains(event.target)) {
      this.close()
    }
  }
}