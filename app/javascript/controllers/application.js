import { Application } from "@hotwired/stimulus"
import { Chart } from "chart.js" ;
import * as Chartjs from "chart.js" ;
const application = Application.start()
const controllers = Object.values(Chartjs).filter(
  (chart) => chart.id !== undefined
) ;
Chart.register(...controllers) ;
// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
