#! /bin/bash
# Interrompe a execução em caso de erro.
set -e

# Instalação do InfluxDB CLI.
if test -z "$(which influx)"
then
  # For Ubuntu/Debian users, add the InfluxData repository with the following commands:
  # influxdata-archive_compat.key GPG Fingerprint: 9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E
  curl -s https://repos.influxdata.com/influxdata-archive_compat.key > influxdata-archive_compat.key
  echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
  echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
  rm --force influxdata-archive_compat.key
  # Then, install the InfluxDB service:
  sudo apt update && sudo sudo apt install influxdb-client --yes
  # Avaliar a necessidade do pacote influxdb para viabilizar o backup dos dados.
else
  echo "O InfluxDB CLI já está instalado."
fi