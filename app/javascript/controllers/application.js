import { Application } from "@hotwired/stimulus"
import GraphModalController from "./graph_modal_controller";

const application = Application.start()
application.register("graph-modal", GraphModalController);

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
