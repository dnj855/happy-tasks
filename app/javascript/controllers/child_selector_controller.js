import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["radio", "label"];

  connect() {}

  select(event){
    const selectedLabel = event.target.closest("label");
    if (selectedLabel) {
      this.radioTarget.checked = true;
    }
  }
}
