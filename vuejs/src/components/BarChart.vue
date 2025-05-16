<template>
    <Bar
      id="expenses-chart"
      :options="chartOptions"
      :data="chartData"
    />
</template>
  
<script>
    import { Bar } from 'vue-chartjs'
    import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

    ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

    var color = window.getComputedStyle(document.body).getPropertyValue('--color-300')

    export default {
        name: 'ExpensesChart',
        components: { Bar },
        data() {
            return {
                chartData: {
                    labels: Array.from({ length: 30 }, (_, i) => `Day ${i + 1}`),
                    datasets: [
                        {
                            label: 'Account balance last 30 days',
                            data: Array.from({ length: 30 }, () => Math.floor(Math.random() * 100)), // Platzhalter-Daten für die letzten 30 Tage
                            backgroundColor: color || '#72DA72', // Fallback-Wert hinzugefügt
                        }
                    ]
                },
                chartOptions: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return value + '$'; // Währungssymbol hinzufügen
                                }
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += context.parsed.y + '$'; // Währungssymbol hinzufügen
                                    }
                                    return label;
                                }
                            }
                        },
                        legend: {
                            display: true,
                            labels: {
                                color: getComputedStyle(document.documentElement).getPropertyValue('--color-500').trim() || '#72DA72' // CSS Variable nutzen
                            }
                        }
                    }
                }
            }
        }
    }
</script>