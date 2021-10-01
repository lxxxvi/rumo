import { Controller } from "@hotwired/stimulus";
import consumer from "../channels/consumer";

export default class extends Controller {
  connect() {
    let token = this.data.get("token");
    this.subscribeTo(token);
  }

  subscribeTo(token) {
    let attendanceController = this;

    this.subscription = consumer.subscriptions.create(
      {
        channel: "VisitChannel",
        token: token
      },
      {
        connected() {},
        disconnected() {},
        received(data) {
          attendanceController.received(data);
        }
      }
    );
  }

  received(data) {
    this.element.innerHTML = data.partial;
  }
}
