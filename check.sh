#!/bin/bash
###################################################################
# Dashboard created for my wireless devices
###################################################################

###################################################################
# Configuração
###################################################################

server='127.0.0.1'
ports='21 22 23 25 53 80 110 443 3306 8006'
# Hostname
hostname=$(hostname)
# Kernel
kernel=$(uname -r)
# Pacotes
packages=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)
# ESSID
essid() {
    if iwgetid -r &>/dev/null; then
        iwgetid -r
    else
        echo "Não conectado"
    fi
}
essid=$(essid)

# Link Quality
link_quality() {
    if iwconfig 2>/dev/null | grep 'Link Quality' &>/dev/null; then
        iwconfig 2>/dev/null | grep 'Link Quality' | awk '{print $2}' | sed 's/Quality=//'
    else
        echo "Não Disponível"
    fi
}
link_quality=$(link_quality)

# Não alterar
title="Proxmox Monitoramento"
version="v1.0"
uptime_figlet=$(uptime | awk '{print $3,$4,$5}' | sed 's/,/ and/' | sed 's/,//' | figlet -f big)
battery_BAT0=$(cat /sys/class/power_supply/BAT0/capacity)


###################################################################
# Funções - HTML
###################################################################

# Header
header_html() {
    echo "
    <!DOCTYPE html>
    <html>
    <head>
        <title>$title</title>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css" integrity="sha512-MV7K8+y+gLIBoVD59lQIYicR65iaqukzvf/nwasF0nqhPay5w/9lJmVM2hMDcnK1OnMGCdVK+iQrJ7lzPJQd1w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
        <style>

            @font-face {
            font-family: "FreePixel";
            src: url("https://sadhost.neocities.org/fonts/FreePixel.ttf") format("truetype");
            }

            @font-face {
            font-family: "SFPixelate";
            src: url("/check/fontes/SFPixelate-Bold.ttf") format("truetype");
            }

            /* This will work on Firefox */
            * {
            scrollbar-width: thin;
            scrollbar-color: magenta yellow;
            }

            /* Targtes on Chrome, Edge, and Safari */
            *::-webkit-scrollbar {
            width: 12px;
            }

            *::-webkit-scrollbar-track {
            background: green;
            }

            *::-webkit-scrollbar-thumb {
            background-color: blue;
            border-radius: 20px;
            border: 3px solid orange;
            }

            h1, .teto {
                font-family: 'SFPixelate', sans-serif;
                color: #79ffa0;
                text-align: center;
            }
            
            body {
                background-color: black;
                font-size: 133%; 
                margin: 0 auto; 
                max-width: 75%; 
                color: #79ffa0;
            }
            #principal {
                padding: 2%;
                background-color: black;
                font-family: sans-serif; 
            }

            blink {
                animation: blinker 0.9s linear infinite;
                color: yellow;
                font-family: sans-serif;
            }

            @keyframes blinker {
                0% { opacity: 20; color: white;}
                50% { opacity: 50; color: red;}
                100% { opacity: 100;}
            }

            .flex-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
            }

           .info-basic-top {
                font-size: 66%;
                color: #ffffff;
                font-family: 'SFPixelate';
            }

            .title-top {
                flex: 2;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }

            marquee {
                font-size: 86%;
                color: #79ffa0;
                font-family: 'SFPixelate';
            }

            .uptime-top, .battery-top {
                background-color: #1e1e1e;
                padding: 2%;
                margin: 0.5%;
                border-radius: 10px;
                align-items: center;
                justify-content: center;
                border: 2px solid #79ffa0;
                flex: 1; /* Para assegurar que cada div vai ocupar o mesmo espaço */
                display: flex;
                flex-direction: column;
                text-align: center;

            }

            .band-1, .band-2 {
                background-color: #1e1e1e;
                padding: 2%;
                margin: 2%;
                border-radius: 10px;
                flex: 1; /* Para assegurar que cada div vai ocupar o mesmo espaço */
                display: flex;
                flex-direction: column;
                border: 2px solid #79ffa0;
            }

            .band-2 {
                align-items: center;
                
            }

            #battery p{
                color: #9d3be1;
            }


            table {
                border-collapse: collapse;
                width: 100%;
                border: 1px solid #ffffff;
                background-color: #1e1e1e;
                text-align: center;
            }
            th, td {
                padding: 5px;
                border-bottom: 1px solid #ddd;
            }
            th {
                background-color: #1e1e1e;
            }

            footer {
                text-align: center;
                font-family: 'SFPixelate';
                color: #9d3be1;
                font-size: 66%;
                margin-top: 2%;
            }


        </style>
    </head>
    <body>
    <div id="principal">
        <div class="flex-container">
            <div class="info-basic-top">
                <p><b>Hostname:</b> $hostname</p>
                <p><b>Kernel:</b> $kernel</p>
                <p><b>Pacotes:</b> $packages</p>
                <p><b>ESSID:</b> $essid</p>
                <p><b>Link Quality:</b> $link_quality</p>
            </div>
            <div class="title-top">
                <h1 style='text-align:center;'>$title - $version</h1>
                <p class='teto' style='text-align:center;'>Última atualização: <blink>$(date | sed 's/-03//')</blink></p>
            </div>
        </div>
        <hr color='cyan'>
        <marquee>
            <i style='color: #9d3be1;'>Dashboard created for my wireless devices</i>
        </marquee>
        <div class="flex-container">
            <div class="uptime-top">
                <span>System Uptime:</span>
                <pre>$uptime_figlet</pre>
            </div>
            <div class="battery-top">
                <span>Battery:</span>
                <div id="battery" style='width: 390px;'></div>
            </div>
        </div>
        <div class="flex-container">
            <div class="band-1">
                <h2 style='color: #79ffa0;text-align: center;'>Informações do Sistema <i class='fas fa-bookmark'></i></h2>
"
}

# Footer
footer_html() {
    echo "
    </div>
    <hr color='cyan'>
    <footer>
        <p>© 2024 - by Abrantedevops</p>
    </footer>
    </body>
    </html>
"
}

# ApexCharts - gauge for Battery
battery_chart() {
    echo "
    <script>
    if (!isNaN($battery_BAT0)) {
   
    var seriesData = [$battery_BAT0];
    var options = {
        series: [seriesData],
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
    } else {
        document.getElementById('battery').innerHTML = '<p>Não Disponível</p>';
    }

    

    var chart = new ApexCharts(document.querySelector('#battery'), options);
    chart.render();
    </script>"
}


# Informações do Sistema e Usuários Conectados
card_1_body() {
    echo "
    <b><i class='fa-brands fa-linux'></i> Distribuição Linux:</b><span style='margin-left:10%;'> $(lsb_release -d | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}') - $(lsb_release -c | awk '{print $2}')</span><br>
    
    <b><i class='fa fa-network-wired'></i> Rodando em:</b><span style='margin-left:10%;'> $(hostname -I | awk '{print $1}')</span><br>

    <b><i class='fa fa-microchip'></i> CPU:</b><span style='margin-left:10%;'> "$(lscpu | grep 'Model name' | awk -F ':' '{print $2}' | sed 's/^ *//')"</span><br>

    <b><i class='fa fa-memory'></i> RAM:</b><span style='margin-left:10%;'> $(free -h | grep Mem | awk '{print $2}')</span><br>

    <b><i class='fa fa-chess-board'></i> Placa-Mãe:</b><span style='margin-left:10%;'> $(dmidecode -t 2 | grep "Manufacturer\|Product\|Version" | awk -F': ' '{print $2}')</span><br>

    <b><i class='fa fa-desktop'></i> Gráficos:</b><span style='margin-left:10%;'> $(lspci | grep VGA | cut -d ' ' -f 2-)</span><br>

    <b><i class='fa fa-hdd'></i> Armazenamento:</b><span style='margin-left:10%;'> $(lsblk -d -o NAME,MODEL,SIZE | grep 'G$')</span><br>
    
    $(users_info)
    
    </div>"
}


# Usuários Conectados
 users_info() {
    users_online=$(who | wc -l)
    echo "<h2 style='color: #79ffa0; text-align: center;'>Usuários Conectados <i class='fas fa-users'></i></h2>"
    if [ $users_online -eq 1 ]; then
        echo "<p><b>Total:</b> $users_online</p>"
        echo "<pre>$(who -H)</pre>"
    else
        echo "<p>Não há usuários conectados.</p>"
    fi
}


# Temperatura e Uso de Disco
card_2_body() {
    echo "<div class='band-2'>"
    echo "<h2 style='color: #79ffa0;text-align: center;'>Temperatura Média <i class='fas fa-thermometer-half'></i></h2>"
    echo "<div id='sensors' style='width: 400px; text-align: center;color: #9d3be1;'></div>"
    echo "<h2 style='color: #79ffa0;text-align: center;'>Disponibilidade de Disco <i class='fas fa-chart-pie'></i></h2>"
    echo "<div id='disk-usage' style='width: 400px; text-align: center;'></div>"
    # Fim div band-2
    echo "</div>"
    # Fim div flex-container
    echo "</div>"
}



# Sensores de Temperatura para CPU, Placa mãe e Armazenamento

temperatura_cpu=$(sensors 2>/dev/null | grep 'Core 0' | awk '{print $3}' | sed 's/+//' | sed 's/°C//')
temperatura_motherboard=$(sensors 2>/dev/null | grep 'temp1' | awk 'BEGIN {sum=0; count=0} $2 != "N/A" {sum+=$2; count++} END {if (count > 0) printf "%.0f", sum/count}')
temperatura_armazenamento=$(hddtemp /dev/sda | awk '{print $4}' | sed 's/°C//')

#ApexCharts - bar graphic of temperature
sensors_info_chart() {
    echo "
    <script>
    if (!isNaN($temperatura_cpu) && !isNaN($temperatura_motherboard) && !isNaN($temperatura_armazenamento)) {
        var seriesData = [$temperatura_cpu, $temperatura_motherboard, $temperatura_armazenamento];
        var options = {
            series: [{
                name: 'Temperatura',
                data: seriesData
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
                    fontSize: '14px',
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

    } else {
        document.getElementById('sensors').innerHTML = '<p>Não Disponível</p>';
    }
        
    var chart = new ApexCharts(document.querySelector('#sensors'), options);
    chart.render();
    </script>"
}


# ApexCharts - donut for Disk Usage
disk_usage_chart() {
    echo "
    <script>
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
    </script>"

}

getservbyport() {
    case $1 in
        21) echo "ftp" ;;
        22) echo "ssh" ;;
        23) echo "telnet" ;;
        25) echo "smtp" ;;
        53) echo "dns" ;;
        80) echo "http" ;;
        110) echo "pop3" ;;
        443) echo "https" ;;
        3306) echo "mysql" ;;
        8006) echo "proxmox" ;;
        *) echo "Desconhecido" ;;
    esac
}

protocolport() {
    case $1 in
        21) echo "TCP" ;;
        22) echo "TCP" ;;
        23) echo "TCP" ;;
        25) echo "TCP" ;;
        53) echo "UDP" ;;
        80) echo "TCP" ;;
        110) echo "TCP" ;;
        443) echo "TCP" ;;
        3306) echo "TCP" ;;
        8006) echo "TCP" ;;
        *) echo "Desconhecido" ;;
    esac
}

# Verificação de Portas
ports_check_code() {
    echo "<table>"
    echo "<tr><th>Porta</th><th>Protocolo</th><th>Estado</th><th>Serviço</th></tr>"
    index=1
    for port in $ports; do
        if nc -z -v -w 1 $server $port &>/dev/null; then
            echo "<tr><td>$port</td><td>$(protocolport $port)</td><td><i class='fas fa-circle' style='color:green;'></i> Aberta</span></td><td>$(getservbyport $port)</td></tr>"
        else
            echo "<tr><td>$port</td><td>$(protocolport $port)</td><td><i class='fas fa-circle' style='color:red;'></i> Fechada</span></td><td>$(getservbyport $port)</td></tr>"
        fi
        index=$((index+1))
    done
    echo "</table>"
}

ports_check() {
    echo "<h2 style='color: #79ffa0; text-align: center;'>Verificação de Portas <i class='fas fa-search'></i></h2>"
    echo "<div class='display-ports'>$(ports_check_code)</div>"
}


# Serviços Status
services_info() {
    echo "<h2 style='color: #79ffa0; text-align: center;'>Status dos Serviços <i class='fas fa-list'></i></h2>"
    echo "<table>"
    echo "<tr><th>Serviço</th><th>Status</th><th>Descrição</th></tr>"
    for service in $(systemctl list-units --type=service --no-legend | awk '{print $1}' | sed 's/\.service//'); do
        if systemctl is-active $service &>/dev/null; then
            echo "<tr><td>$service</td><td><span style='background-color:green; color:white; padding: 3px;'> Rodando</span></td><td>$(systemctl show -p Description $service | awk -F'=' '{print $2}')</td></tr>"
        else
            echo "<tr><td>$service</td><td><span style='background-color:red; color:white; padding: 3px;'> Parado</span></td><td>$(systemctl show -p Description $service | awk -F'=' '{print $2}')</td></tr>"
        fi
    done
    echo "</table>"
} 



###################################################################
# Início
###################################################################


header_html

battery_chart

card_1_body
card_2_body
sensors_info_chart
disk_usage_chart


ports_check
services_info

footer_html
