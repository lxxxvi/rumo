import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["urlIdentifierInput", "urlIdentifierOutput"];

  connect() {
    this.updatePreview();
  }

  updatePreview() {
    this.urlIdentifierOutputTarget.innerHTML = this.urlIdentifierInputTarget.value;
  }
}
