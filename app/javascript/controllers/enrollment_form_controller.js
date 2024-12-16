import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="enrollment-form"
export default class extends Controller {
  static targets = ["neuroTypeField", "autonomySlider", "autonomyValue"];

  connect() {
    if (this.hasAutonomySliderTarget) {
      this.updateSliderValue();
    }
  }

  toggleNeuroType(event) {
    const checkbox = event.target;
    if (checkbox.checked) {
      this.neuroTypeFieldTarget.classList.remove("hidden");
    } else {
      this.neuroTypeFieldTarget.classList.add("hidden");
    }
  }

  updateSliderValue() {
    const value = this.autonomySliderTarget.value;
    this.autonomyValueTarget.textContent = value;
  }
}
