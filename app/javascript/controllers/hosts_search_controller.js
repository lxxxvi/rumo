import { Controller } from "stimulus";
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = ["searchField"];


  connect() {
    this.connectToSearchChannel();
  }

  connectToSearchChannel(token) {
    let thisController = this;

    this.searchChannel = consumer.subscriptions.create(
      {
        channel: "SearchChannel"
      },
      {
        received(data) {
          thisController.received(data);
        }
      }
    );
  }

  received(data) {
    this.element.innerHTML = data.partial;
  }

  search(event) {
    this.searchChannel.send({ query: event.target.value })
  }
}
