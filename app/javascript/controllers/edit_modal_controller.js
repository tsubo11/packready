import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "panel"]

  open() {
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    const errorList = this.element.querySelector(".text-red-500")
    if (errorList) errorList.remove()
    const nameInput = this.element.querySelector("input[name='item[name]']")
    const originalName = this.element.querySelector("[data-item-name]").dataset.itemName
    if (nameInput) nameInput.value = originalName
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