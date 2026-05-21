import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "panel", "timing", "title"]

  open(event) {
    const timing = event.currentTarget.dataset.timing
    this.timingTarget.value = timing
    this.titleTarget.textContent = timing === "morning" ? "持ち物を追加（当日）" : "持ち物を追加（前日まで）"
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    const errorDiv = document.getElementById("modal-form-errors")
    if (errorDiv) errorDiv.remove()
  }

  clickOutside(event) {
    if (!this.panelTarget.contains(event.target)) {
      this.close()
    }
  }

  submitEnd(event) {
    if (event.detail.success) {
      this.close()
    }
  }
}