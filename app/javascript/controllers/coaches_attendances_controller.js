import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["actionMenu"]

  connect() {
    this.displayMenuActions();
  }

  get openMenuTokens() {
    return this.data.get("openMenuTokens").split(",");
  }

  set openMenuTokens(tokens) {
    this.data.set("openMenuTokens", tokens.join(","));
    this.displayMenuActions();
  }

  displayMenuActions() {
    let openMenuTokens = this.openMenuTokens;

    this.actionMenuTargets.forEach((element) => {
      let attendanceToken = element.closest("[data-attendance-token]").dataset.attendanceToken;
      element.classList.toggle('hidden', !openMenuTokens.includes(attendanceToken));
    });
  }

  toggleActionMenu(event) {
    let attendanceToken = event.currentTarget.dataset.attendanceToken;

    this.toggleOpenMenuToken(attendanceToken);
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
}
