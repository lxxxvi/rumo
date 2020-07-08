import { Controller } from "stimulus";
import RumoStorage from "../storages/rumo_storage";
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = ["status", "forward"]

  connect() {
    this.rumoStorage = new RumoStorage(window);
    let token = this.data.get("token");

    if(this.forwardTargets.length > 0) {
      this.rumoStorage.mergeToken(token);
      window.location.href = this.forwardTarget.href;
    } else {
      if(typeof token === "string" && token.length > 0) {
        this.subscribeTo(token);
      }
    }
  }

  subscribeTo(token) {
    let attendanceController = this;

    this.subscription = consumer.subscriptions.create(
      {
        channel: "AttendanceChannel",
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
