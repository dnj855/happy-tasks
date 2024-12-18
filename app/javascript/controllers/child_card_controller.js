import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["body", "chevron"]; // Définit une cible pour la section body et chevron

  connect() {
    // Vérifie si la section body est initialement visible
    const isVisible = this.bodyTarget.style.display === "block";

    // Ajoute ou enlève la classe 'is-open' en conséquence
    if (isVisible) {
      this.chevronTarget.classList.add('is-open');
    } else {
      this.chevronTarget.classList.remove('is-open');
    }
  }

  toggle() {
    const isVisible = this.bodyTarget.style.display === "block";
    this.bodyTarget.style.display = isVisible ? "none" : "block";
    this.chevronTarget.classList.toggle('is-open');
  }
}
