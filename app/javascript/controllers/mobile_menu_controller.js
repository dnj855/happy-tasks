import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["overlay", "content"];
  connect() {}

  show(e) {
    e.preventDefault();
    this.overlayTarget.classList.add("mobile-menu__overlay--visible");
    this.contentTarget.classList.add("mobile-menu__content--visible");
    document.body.style.overflow = "hidden"; // Bloque le scroll du body
    document.body.style.position = "fixed"; // Empêche le bounce sur iOS
    document.body.style.width = "100%";
  }
}
