// app/javascript/controllers/children_form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["childrenContainer"];
  static values = {
    maxChildren: { type: Number, default: 10 },
  };

  addChild(event) {
    event.preventDefault();

    if (this.childrenContainerTarget.children.length >= this.maxChildrenValue) {
      return;
    }

    const timestamp = new Date().getTime();
    const template =
      this.childrenContainerTarget.firstElementChild.cloneNode(true);

    // Mise à jour des IDs et noms
    template.querySelectorAll("[name]").forEach((input) => {
      input.name = input.name.replace(/\d+/, timestamp);
      input.id = input.id.replace(/\d+/, timestamp);
    });

    // Reset des valeurs
    template.querySelectorAll("input, select").forEach((input) => {
      if (input.type === "checkbox") {
        input.checked = false;
      } else if (input.type === "range") {
        input.value = 3; // Valeur par défaut du slider
        const valueDisplay = template.querySelector(
          "[data-enrollment-form-target='autonomyValue']"
        );
        if (valueDisplay) valueDisplay.textContent = "3";
      } else {
        input.value = "";
      }
    });

    const neuroTypeField = template.querySelector(
      "[data-enrollment-form-target='neuroTypeField']"
    );
    if (neuroTypeField) {
      neuroTypeField.classList.add("hidden");

      // Réinitialiser le select de neuroatypie
      const neuroTypeSelect = neuroTypeField.querySelector("select");
      if (neuroTypeSelect) {
        neuroTypeSelect.selectedIndex = 0;
      }
    }

    template.classList.add("enrollment__form__group--entering");

    this.childrenContainerTarget.appendChild(template);

    setTimeout(() => {
      template.classList.remove("enrollment__form__group--entering");
    }, 300);
  }

  removeChild(event) {
    event.preventDefault();

    // Empêcher la suppression s'il ne reste qu'un seul enfant
    if (this.childrenContainerTarget.children.length <= 1) {
      return;
    }

    const childGroup = event.target.closest(".enrollment__form__group");
    childGroup.classList.add("enrollment__form__group--leaving");

    setTimeout(() => {
      childGroup.remove();
    }, 300);
  }
}
