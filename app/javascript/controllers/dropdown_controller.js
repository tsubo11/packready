import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.stopPropagation()
    const isHidden = this.menuTarget.classList.contains("hidden")
    this.closeAll()
    if (isHidden) {
      this.menuTarget.classList.remove("hidden")
    }
  }

  close() {
    this.menuTarget.classList.add("hidden")
  }

  closeAll() {
    document.querySelectorAll('[data-dropdown-target="menu"]').forEach(menu => {
      menu.classList.add("hidden")
    })
  }
}