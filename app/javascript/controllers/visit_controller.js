import { Controller } from "@hotwired/stimulus";
import RumoStorage from "../storages/rumo_storage";

export default class extends Controller {
  static targets = ["contactField", "nameField"]

  connect() {
    this.rumoStorage = new RumoStorage(window);

    this.autofill(this.contactFieldTarget, this.rumoStorage.contact);
    this.autofill(this.nameFieldTarget, this.rumoStorage.name);
  }

  autofill(target, value) {
    target.value = target.value || value;
  }

  updateStorage() {
    return new Promise((resolve, reject) => {
      this.rumoStorage.contact = this.contactFieldTarget.value;
      this.rumoStorage.name = this.nameFieldTarget.value;

      resolve('OK');
    });
  }

  update(event) {
    event.preventDefault();
    this.updateStorage().then((result) => { event.target.submit() });
  }
}
