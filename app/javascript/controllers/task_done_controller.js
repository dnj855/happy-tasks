import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["taskDone"];
  static values = { id: Number, userRole: String };

  connect() {}

  async updateTask(event) {
    console.log("Toggle switch");
    const isChecked = event.target.checked;

    if (this.userRoleValue === "parent") {
      try {
        const response = await fetch(`/tasks/${this.idValue}/validate`, {
          method: "PATCH",
          headers: {
            "X-CSRF-Token": document.querySelector('[name="csrf-token"]')
              .content,
            "Content-Type": "application/json",
            Accept: "application/json", // On change le format accepté
          },
          body: JSON.stringify({
            validated: isChecked,
          }),
        });

        if (!response.ok) {
          throw new Error("Erreur lors de la mise à jour de la tâche");
        }

        const data = await response.json();
        console.log("Tâche validée", data);
        // Les points seront mis à jour automatiquement via le broadcast
      } catch (error) {
        console.error(error);
        event.target.checked = !isChecked;
      }
    }

    if (this.userRoleValue === "child") {
      // Cette partie reste inchangée car elle utilise déjà JSON
      try {
        const response = await fetch(`/tasks/${this.idValue}/declare-done`, {
          method: "PATCH",
          headers: {
            "X-CSRF-Token": document.querySelector('[name="csrf-token"]')
              .content,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            completed: isChecked,
          }),
        });

        if (!response.ok) {
          throw new Error("Erreur lors de la mise à jour de la tâche");
        }

        const data = await response.json();
        console.log("Tâche effectuée par l'enfant", data);
      } catch (error) {
        console.error(error);
        event.target.checked = !isChecked;
      }
    }
  }
}
