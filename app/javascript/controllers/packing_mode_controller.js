import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["aiFields"]

  toggle(event) {
    // 選択されたラジオボタンの値が"ai"かどうかを確認し、結果をisAiに入れる
    const isAi = event.target.value === "ai"
    // AI選択時はaiFieldsを表示、手動選択時は非表示にする
    this.aiFieldsTarget.hidden = !isAi
  }
}