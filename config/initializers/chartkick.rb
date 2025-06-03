Chartkick.options = {
  height: "300px",
  colors: [ "#000" ],
  library: {
    layout: {
      padding: { top: 16, bottom: 0, left: 8, right: 8 }
    },
    elements: {
      bar: {
        borderRadius: { topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 0 },
        borderSkipped: "bottom"
      }
    },
    plugins: {
      legend: {
        display: false
      },
      tooltip: {
        backgroundColor: "#f9fafb",
        titleColor: "#111827",
        bodyColor: "#4b5563",
        borderColor: "#e5e7eb",
        borderWidth: 1,
        padding: 12
      }
    },
    scales: {
      x: {
        ticks: {
          color: "#6b7280",
          font: { family: "Inter, sans-serif", size: 12 }
        },
        grid: {
          display: false,
          drawBorder: false
        }
      },
      y: {
        ticks: {
          color: "#6b7280",
          font: { family: "Inter, sans-serif", size: 12 }
        },
        grid: {
          display: false,
          drawBorder: false
        }
      }
    }
  }
}
