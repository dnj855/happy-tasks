import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

// Connects to data-controller="task-done"
export default class extends Controller {
  static targets = ["taskDone"];
  static values = { id: Number, userRole: String };

  connect() {}

  async updateTask(event) {
    console.log("Toggle switch");
    const isChecked = event.target.checked;

    if (this.userRoleValue === "parent") {
      // Envoie la requête PATCH pour valider/dévalider la tâche
      try {
        const response = await fetch(`/tasks/${this.idValue}/validate`, {
          method: "PATCH",
          headers: {
            "X-CSRF-Token": document.querySelector('[name="csrf-token"]')
              .content,
            "Content-Type": "application/json",
            Accept: "text/vnd.turbo-stream.html",
          },
          body: JSON.stringify({
            validated: isChecked,
          }),
        });

        //.then(response => {
        if (!response.ok) {
          throw new Error("Erreur lors de la mise à jour de la tâche");
        }
        const streamContent = await response.text();
        Turbo.renderStreamMessage(streamContent);
        //return response.json();
        //})
        //.then(data => {
        //console.log('Tâche mise à jour', data);
        //// Mise à jour des points de l'enfant dans l'interface
        //const childPoints = data.points;
        //const taskElement = event.target.closest('.task');

        //taskElement.querySelector('.child-day-points').textContent = childPoints.day_points;
        //taskElement.querySelector('.child-week-points').textContent = childPoints.week_points;
        //taskElement.querySelector('.child-month-points').textContent = childPoints.month_points;

        //    })
      } catch (error) {
        console.error(error);
        event.target.checked = !isChecked;
      }
    }

    if (this.userRoleValue === "child") {
      // Envoie la requête PATCH pour signaler que la tâche a été effectuée par l'enfant
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
