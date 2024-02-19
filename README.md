# Wireless Device Monitoring

<h3 align="justify"> This project is a simple dashboard to monitor my wireless devices connected to my home network. You know, right? Need to take more care of them. </h3>

<p align="center">
    <img src="img/dash_view.gif" alt="Dashboard View" width="100%">
</p>

<h2 align="justify"> Steps</h2>

1. Clone the repository
```bash
git clone https://github.com/abrantedevops/dashboard_wireless.git ; cd dashboard_wireless
```

2. Make the 'check.sh' file executable
```bash
chmod +x check.sh
```

3. Run docker-compose
```bash
docker-compose up -d
```

4. Generate the index.html file and save it in the html folder
```bas
./check.sh > html/index.html
```

5. Access the dashboard
```bash
http://(ip_server):8080/check
```

6. (Optional) Create a cron job to update the index.html file, for example, every 1 minute
```bash
echo -e "*/1 *\t* * *\troot\t$(pwd)/check.sh > $(pwd)/html/index.html" >> /etc/crontab
```