import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["overlay", "modal", "content"];
  scrollPosition = 0;

  async open(event) {
    event.preventDefault();
    this.scrollPosition = window.scrollY;

    try {
      // Afficher d'abord la modale vide avec un loader
      this.overlayTarget.classList.add("open");
      this.modalTarget.classList.add("open");
      this.contentTarget.innerHTML =
        '<div class="loading">Chargement des statistiques...</div>';
      this._disableScroll();

      // Charger les statistiques
      const statsUrl = `/dashboard/statistics`;
      const response = await fetch(statsUrl, {
        headers: { Accept: "text/html" },
      });
      const html = await response.text();

      // Mettre à jour le contenu en incluant le bouton de fermeture
      this.contentTarget.innerHTML = `
        <button data-action="click->graph-modal#close" class="modal__close">&times;</button>
        ${html}
      `;
    } catch (error) {
      console.error("Erreur lors de la mise à jour de la modale :", error);
      this.contentTarget.innerHTML = `
        <button data-action="click->graph-modal#close" class="modal__close">&times;</button>
        <div class="error">Une erreur est survenue lors du chargement des statistiques.</div>
      `;
    }
  }

  close(event) {
    event.preventDefault();
    this.overlayTarget.classList.remove("open");
    this.modalTarget.classList.remove("open");
    this._enableScroll();
  }

  stopPropagation(event) {
    event.stopPropagation();
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
