import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="graph-modal"
export default class extends Controller {
  static targets = ["modal"];
  connect() {
    //console.log("connecté")
  }
  open() {
    //console.log("connecté");
    //console.log("Targets :", this.hasModalTarget);
    this.modalTarget.classList.remove("hidden");
    this.modalTarget.classList.add("open");
    //console.log("Classes actuelles :", this.modalTarget.classList.value);
  }

  close() {
    this.modalTarget.classList.remove("open");
    setTimeout(() => this.modalTarget.classList.add("hidden"), 300);
  }
}
