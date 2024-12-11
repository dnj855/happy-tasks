import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  static values = { award: Number };

  async giveAward(event) {
    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    const isChecked = event.target.checked;

    try {
      const response = await fetch(`/awards/${this.awardValue}`, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
          Accept: "text/vnd.turbo-stream.html",
        },
        body: JSON.stringify({
          given: isChecked,
        }),
      });

      if (!response.ok) {
        event.target.checked = !isChecked;
        throw new Error("Network response was not ok");
      }

      // Traiter explicitement la réponse Turbo
      const streamContent = await response.text();
      Turbo.renderStreamMessage(streamContent);
    } catch (error) {
      console.error("Error:", error);
      event.target.checked = !isChecked;
    }
  }
}
