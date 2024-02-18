var options = {
    series: [$battery_BAT0],
    labels: ['Bateria'],
    colors: ['#79ffa0'],
    chart: {
        height: 380,
        type: 'radialBar',
        sparkline: {
            enabled: true
        }
    },
    plotOptions: {
        radialBar: {
            startAngle: -90,
            endAngle: 90,
            hollow: {
                size: '79%',
            },
        dataLabels: {
            name: {
                show: false,
            },
            value: {
                show: true,
                offsetY: -40,
                fontSize: '40px',
                color: '#79ffa0',
            }
        }
    }},
    fill: {
        type: 'gradient',
        gradient: {
            shade: 'dark',
            type: 'horizontal',
            shadeIntensity: 0.5,
            gradientToColors: ['#ec2400'],
            inverseColors: true,
            opacityFrom: 1.0,
            opacityTo: 1.0,
            stops: [0, 100]
        }
    },
};

var chart = new ApexCharts(document.querySelector('#battery'), options);
chart.render();

// ---

temperatura_cpu=$(sensors 2>/dev/null | grep 'Core 0' | awk '{print $3}' | sed 's/+//' | sed 's/°C//')
    temperatura_motherboard=$(sensors 2>/dev/null | grep 'temp1' | awk 'BEGIN {sum=0; count=0} $2 != "N/A" {sum+=$2; count++} END {if (count > 0) printf "%.0f", sum/count}')
    temperatura_armazenamento=$(hddtemp /dev/sda | awk '{print $4}' | sed 's/°C//')
    var options = {
        series: [{
            data: [temperatura_cpu, temperatura_motherboard, temperatura_armazenamento]
        }],
        chart: {
            height: 350,
            type: 'bar',
            events: {
                click: function(chart, w, e) {
                    // console.log(chart, w, e)
                }
            }
        },
        colors: ['#79ffa0'],
        plotOptions: {
            bar: {
                columnWidth: '50%',
                endingShape: 'rounded'
            }
        },
        dataLabels: {
            enabled: false
        },
        stroke: {
            width: 2
        },

        xaxis: {
            categories: ['CPU', 'Placa-Mãe', 'Armazenamento'],
            labels: {
                style: {
                    colors: '#fff',
                    fontSize: '14px'
                }
            }
        },
        yaxis: {
            title: {
                text: 'Temperatura (°C)',
                style: {
                    color: '#fff',
                    fontSize: '14px'
                }
            },
            labels: {
                style: {
                    colors: '#fff',
                    fontSize: '14px'
                }
            }
        },
        fill: {
            opacity: 0.4
        },
        tooltip: {
            y: {
                formatter: function (val) {
                    return val + '°C'
                }
            }
        }
    };

    var chart = new ApexCharts(document.querySelector('#sensors'), options);
    chart.render();

// ---

value_total_disk = $(df -h 2>/dev/null | grep '/$' | awk '{print $2}' | sed 's/G//')
    value_used_disk = $(df -h 2>/dev/null | grep '/$' | awk '{print $3}' | sed 's/G//')
    value_free_disk = $(df -h 2>/dev/null | grep '/$' | awk '{print $4}' | sed 's/G//')
    var options = {
        series: [value_used_disk, value_free_disk],
        chart: {
        type: 'donut',
    },
    labels: ['Usado', 'Livre'],
    legend: {
        labels: {
            colors: ['#fff', '#fff']
        }
    },
    responsive: [{
        breakpoint: 480,
        options: {
            legend: {
                position: 'bottom'
            },
        }
    }]
    };

    var chart = new ApexCharts(document.querySelector('#disk-usage'), options);
    chart.render();