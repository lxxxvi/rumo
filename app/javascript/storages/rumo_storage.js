export default class RumoStorage {
  constructor(window) {
    this.storage = window.localStorage;
  }

  readTokens() {
    let tokens = this.storage.getItem("tokens");

    if(tokens == null) {
      return [];
    }

    return tokens.split(",");
  }

  writeTokens(values) {
    this.storage.setItem("tokens", values.join(","));
  }

  mergeToken(token) {
    let tokens = this.readTokens();

    if(tokens.includes(token)) {
      return;
    } else {
      tokens.push(token);
      this.writeTokens(tokens);
    }
  }
}
