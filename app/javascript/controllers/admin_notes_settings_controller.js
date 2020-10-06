import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['checkbox', 'textarea']

  connect() {
    this.toggleNotesText()
  }

  toggleNotesText() {
    let checkboxState = this.checkboxTarget.checked;
    this.textareaTarget.classList.toggle('hidden', !checkboxState);
  }
}
