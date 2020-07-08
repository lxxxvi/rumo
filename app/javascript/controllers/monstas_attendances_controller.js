import { Controller } from "stimulus";
import RumoStorage from "../storages/rumo_storage";

export default class extends Controller {
  connect() {
    this.storage = new RumoStorage(window);
    this.loadTokens();
  }

  loadTokens() {
    let tokens = this.storage.readTokens();
    if(tokens.length > 0) {
      this.element.innerHTML = 'Loading ...';

      fetch(`${this.data.get("url")}/${tokens.join(",")}`)
        .then(response => response.text())
        .then(html => {
          this.element.innerHTML = html;
      });
    }
  }
}
