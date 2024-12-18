import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["overlay", "modal", "content"];
  // static values = { familyId: Number };  Récupération de l'id de la famille
  scrollPosition = 0;

  // Ouvrir la modale
  open(event) {
    event.preventDefault();
    this.scrollPosition = window.scrollY;

    this.overlayTarget.classList.add("open");
    this.modalTarget.classList.add("open");
    this._disableScroll();
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
