import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["body"]; // Définit une cible pour la section body

  toggle() {
    // Affiche ou masque la section body de cette carte uniquement
    const isVisible = this.bodyTarget.style.display === "block";
    this.bodyTarget.style.display = isVisible ? "none" : "block";
  }
}
