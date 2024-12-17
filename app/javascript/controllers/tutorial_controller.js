import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["slide"];

  connect() {
    this.currentSlide = 0;
    this.showSlide(0);
  }

  nextSlide() {
    if (this.currentSlide < this.slideTargets.length - 1) {
      this.transitionSlides(this.currentSlide, this.currentSlide + 1);
    }
  }

  transitionSlides(currentIndex, nextIndex) {
    this.slideTargets[currentIndex].classList.add("slide-out-left");

    setTimeout(() => {
      this.slideTargets[currentIndex].classList.add("hidden");
      this.slideTargets[currentIndex].classList.remove("slide-out-left");

      this.slideTargets[nextIndex].classList.remove("hidden");
      this.slideTargets[nextIndex].classList.add("slide-in-right");

      setTimeout(() => {
        this.slideTargets[nextIndex].classList.remove("slide-in-right");
      }, 500);

      this.currentSlide = nextIndex;
    }, 500);
  }
}
