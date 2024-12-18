import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["overlay", "modal", "content"];
  // static values = { familyId: Number };  Récupération de l'id de la famille
  scrollPosition = 0;

  // Ouvrir la modale
  async open(event) {
    event.preventDefault();
    this.scrollPosition = window.scrollY;

    const url = window.location.href;
    try {
      const response = await fetch(url, { headers: { "Accept": "text/html" } });
      const html = await response.text();
      this.contentTarget.innerHTML = this.extractContent(html);
      this.overlayTarget.classList.add("open");
      this.modalTarget.classList.add("open");
      this._disableScroll();
    } catch (error) {
      console.error("Erreur lors de la mise à jour de la modale :", error);
    }
  }

  // Fermer la modale
  close(event) {
    event.preventDefault();
    this.overlayTarget.classList.remove("open");
    this.modalTarget.classList.remove("open");
    this._enableScroll();
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  extractContent(html) {
    // Parse la réponse HTML pour extraire uniquement le contenu de la modale
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, "text/html");
    const modalContent = doc.querySelector("#graph-modal .modal__content");
    return modalContent ? modalContent.innerHTML : "";
  }

  _disableScroll() {
    document.body.style.overflow = "hidden";
    document.body.style.position = "fixed";
    document.body.style.width = "100%";
  }

  _enableScroll() {
    document.body.style.overflow = "";
    document.body.style.position = "";
    document.body.style.width = "";
    window.scrollTo(0, this.scrollPosition);
  }
}
