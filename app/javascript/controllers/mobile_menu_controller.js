import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["overlay", "content"];
  static values = { childId: Number };
  scrollPosition = 0;

  show(event) {
    event.preventDefault();
    this.scrollPosition = window.scrollY;
    this.overlayTarget.classList.add("mobile-menu__overlay--visible");
    this.contentTarget.classList.add("mobile-menu__content--visible");
    document.body.style.overflow = "hidden";
    document.body.style.position = "fixed";
    document.body.style.width = "100%";
  }

  hide(event) {
    event.preventDefault();
    this.overlayTarget.classList.remove("mobile-menu__overlay--visible");
    this.contentTarget.classList.remove("mobile-menu__content--visible");
    document.body.style.overflow = "";
    document.body.style.position = "";
    document.body.style.width = "";
    window.scrollTo(0, this.scrollPosition);
  }

  stopPropagation(event) {
    event.stopPropagation();
  }
}
