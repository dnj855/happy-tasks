import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("PointsController connected");
  }

  increment() {
    const input = this.inputTarget;
    let value = parseInt(input.value, 10);
    input.value = value + 1;
  }

  decrement() {
    const input = this.inputTarget;
    let value = parseInt(input.value, 10);
    if (value > 0) {
      input.value = value - 1;
    }
  }
}
