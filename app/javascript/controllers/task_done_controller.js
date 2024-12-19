import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["taskDone"];
  static values = {
    id: Number,
    userRole: String,
    status: String,
  };

  connect() {
    this.updateToggleState();
  }

  statusValueChanged() {
    this.updateToggleState();
  }

  updateToggleState() {
    const checkbox = this.element.querySelector(".task-switch__toggle");
    if (!checkbox) return;

    const status = this.statusValue;
    const userRole = this.userRoleValue;

    checkbox.checked =
      status === "validated" || (status === "done" && userRole === "child");

    checkbox.disabled = status === "validated";
  }

  async updateTask(event) {
    console.log("Toggle switch clicked");
    console.log("User role:", this.userRoleValue);
    console.log("Task status:", this.statusValue);
    console.log("isChecked:", event.target.checked);

    const isChecked = event.target.checked;

    if (this.userRoleValue === "parent") {
      console.log("Entering parent validation branch");
      try {
        console.log("Sending validate request");
        const response = await fetch(`/tasks/${this.idValue}/validate`, {
          method: "PATCH",
          headers: {
            "X-CSRF-Token": document.querySelector('[name="csrf-token"]')
              .content,
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          body: JSON.stringify({
            validated: true,
          }),
        });

        if (!response.ok) {
          throw new Error("Erreur lors de la validation de la tâche");
        }

        const data = await response.json();
        console.log("Tâche validée", data);
      } catch (error) {
        console.error(error);
        event.target.checked = !isChecked;
      }
    } else if (this.userRoleValue === "child") {
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
        event.target.checked = data.completed;

        // Forcer la mise à jour du statut et du toggle
        if (data.completed) {
          this.statusValue = "done";
          this.updateToggleState();
        }
      } catch (error) {
        console.error(error);
        event.target.checked = !isChecked;
      }
    }
  }
}
