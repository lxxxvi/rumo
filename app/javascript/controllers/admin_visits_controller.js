import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["actionMenu"]

  connect() {
    this.displayMenuActions();
  }

  get openMenuTokens() {
    return (window.sessionStorage.getItem("openMenuTokens") || '').split(",");
  }

  set openMenuTokens(tokens) {
    window.sessionStorage.setItem("openMenuTokens", tokens.join(","));
    this.displayMenuActions();
  }

  displayMenuActions() {
    let openMenuTokens = this.openMenuTokens;

    this.actionMenuTargets.forEach((element) => {
      const visitToken = this.visitTokenFromParent(element);
      element.classList.toggle('hidden', !openMenuTokens.includes(visitToken));
    });
  }

  toggleActionMenu(event) {
    let visitToken = this.visitTokenFromParent(event.target);

    this.toggleOpenMenuToken(visitToken);
  }

  toggleOpenMenuToken(token) {
    let openMenuTokens = this.openMenuTokens;
    let tokenIndex = openMenuTokens.indexOf(token);

    if (tokenIndex < 0) {
      openMenuTokens.push(token);
    } else {
      openMenuTokens.splice(tokenIndex, 1);
    }

    this.openMenuTokens = openMenuTokens;
  }

  visitTokenFromParent(element) {
    return element.closest("[data-visit-token]").dataset.visitToken;
  }
}
