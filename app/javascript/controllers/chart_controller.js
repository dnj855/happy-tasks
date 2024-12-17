import { Controller } from "@hotwired/stimulus"
import { Chart } from "chart.js"; // Oh les belles accolades autour de Chart :o
// En reprenant les étapes de l'exercice optio des challenge de je ne sais plus quand
// ça a fini par marcher ...

// Connects to data-controller="chart"
export default class ChartController extends Controller {
  static values = {
    taskCounts: Object,  // Récupère les tâches sous forme d'objet
  }
  connect() {
    console.log("chart.controller connected");
    this.render();
  }
  render() {
    const ctx = this.element.querySelector("canvas").getContext("2d");

    // Récupérer les données à partir des valeurs transmises par les data-attributes
    const taskCounts = this.taskCountsValue;


    if (!taskCounts) {
      console.error("Aucune donnée de tâche trouvée");
      return;
    }
    // récupération des labels "animaux, apprentissage, ..."
    const labels = Object.keys(taskCounts);

    // récupération du nombre de tâches pour chaque catégorie "animaux, apprentissage, ..."
    const data = labels.map(taskType => taskCounts[taskType]);

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '',
          data: data,
          borderColor: [ // 7 fois la même chose c'est moche mais ça ira pour ce soir
            'rgb(0,0,0)',
            'rgb(0,0,0)',
            'rgb(0,0,0)',
            'rgb(0,0,0)',
            'rgb(0,0,0)',
            'rgb(0,0,0)',
            'rgb(0,0,0)',
          ],
          borderWidth: 1,
          backgroundColor: [ // les couleurs happy-tasks
            ' #f2f4f5',
            ' #146a8a',
            ' #06d6a0',
            ' #b9174a',
            ' #ffd166',
            ' #404446',
            ' #48a7f8'
          ],
          fill: false
        }]
      },
      options: {
        plugins: {
          legend: {
            display: false, // Cache la légende pour éviter les actions "Reset"
            },
          tooltip: {
            enabled: true, // Active les tooltips
            }
          },
        responsive: true,
        scales: {
          x: {
            title: {
              display: true,
              text: ''
            },
            ticks: {
              maxRotation: 45, // Rotation maximale des labels si jamais ...
              minRotation: 0,  // Rotation minimale
              font: {
                size: 10 // Taille de la police pour les labels
              },
              callback: function(value) {
                // Tronque les labels à une certaine longueur comme ça ça tient
                const label = this.getLabelForValue(value);
                return label.length > 4 ? label.substring(0, 4) + '.' : label;
              }
            }
          },
          y: {
            title: {
              display: true,
              text: ``
            }
          }
        }
      }
    });
  }
}
