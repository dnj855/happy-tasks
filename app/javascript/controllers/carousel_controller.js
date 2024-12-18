import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "slides",
    "slide",
    "prevButton",
    "nextButton",
    "indicators",
  ];

  connect() {
    this.currentIndex = 0;
    this.touchStartX = 0;
    this.touchEndX = 0;
    this.updateButtonStates();

    this.slidesTarget.addEventListener("touchstart", (e) =>
      this.handleTouchStart(e)
    );
    this.slidesTarget.addEventListener("touchmove", (e) =>
      this.handleTouchMove(e)
    );
    this.slidesTarget.addEventListener("touchend", () => this.handleTouchEnd());
  }

  next() {
    if (this.currentIndex < this.slideTargets.length - 1) {
      this.currentIndex++;
      this.updateSlidePosition();
    }
  }

  previous() {
    if (this.currentIndex > 0) {
      this.currentIndex--;
      this.updateSlidePosition();
    }
  }

  goToSlide(event) {
    const index = parseInt(event.currentTarget.dataset.carouselSlideIndex);
    this.currentIndex = index;
    this.updateSlidePosition();
  }

  handleTouchStart(event) {
    this.touchStartX = event.touches[0].clientX;
  }

  handleTouchMove(event) {
    this.touchEndX = event.touches[0].clientX;
    event.preventDefault();
  }

  handleTouchEnd() {
    const diff = this.touchStartX - this.touchEndX;
    const threshold = 50;

    if (Math.abs(diff) > threshold) {
      if (diff > 0) {
        this.next();
      } else {
        this.previous();
      }
    }
  }

  updateSlidePosition() {
    const offset = this.currentIndex * -100;
    this.slidesTarget.style.transform = `translateX(${offset}%)`;
    this.updateButtonStates();
    this.updateIndicators();
  }

  updateButtonStates() {
    this.prevButtonTarget.disabled = this.currentIndex === 0;
    this.nextButtonTarget.disabled =
      this.currentIndex === this.slideTargets.length - 1;
  }

  updateIndicators() {
    this.indicatorsTarget
      .querySelectorAll(".tasks-carousel__indicator")
      .forEach((indicator, index) => {
        indicator.classList.toggle("is-active", index === this.currentIndex);
      });
    this.slideTargets.forEach((slide, index) => {
      slide.classList.toggle("is-active", index === this.currentIndex);
    });
  }
}
