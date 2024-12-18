import { Controller } from "@hotwired/stimulus";
import { Chart } from "chart.js";

export default class ChartController extends Controller {
  static values = {
    taskCounts: Object,
  };

  connect() {
    console.log("chart.controller connected");
    this.initializeChart();
  }

  disconnect() {
    this.destroyChart();
  }

  initializeChart() {
    // Détruire toute instance existante sur ce canvas
    const existingChart = Chart.getChart(this.canvas);
    if (existingChart) {
      existingChart.destroy();
    }

    const taskCounts = this.taskCountsValue;
    if (!taskCounts) {
      console.error("Aucune donnée de tâche trouvée");
      return;
    }

    const labels = Object.keys(taskCounts);
    const data = labels.map((taskType) => taskCounts[taskType]);

    this.chart = new Chart(this.canvas.getContext("2d"), {
      type: "bar",
      data: {
        labels: labels,
        datasets: [
          {
            label: "",
            data: data,
            borderWidth: 1,
            backgroundColor: [
              "#f2f4f5",
              "#146a8a",
              "#06d6a0",
              "#b9174a",
              "#ffd166",
              "#404446",
              "#48a7f8",
            ],
            fill: false,
          },
        ],
      },
      options: {
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            enabled: true,
          },
        },
        responsive: true,
        scales: {
          x: {
            title: {
              display: true,
              text: "",
            },
            ticks: {
              maxRotation: 45,
              minRotation: 0,
              font: {
                size: 10,
              },
              callback: function (value) {
                const label = this.getLabelForValue(value);
                return label.length > 4 ? label.substring(0, 4) + "." : label;
              },
            },
          },
          y: {
            title: {
              display: true,
              text: ``,
            },
          },
        },
      },
    });
  }

  destroyChart() {
    const existingChart = Chart.getChart(this.canvas);
    if (existingChart) {
      existingChart.destroy();
    }
  }

  get canvas() {
    return this.element.querySelector("canvas");
  }
}
