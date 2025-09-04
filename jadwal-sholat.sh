#!/bin/bash

# Ambil data sholat
data=$(curl -s -A "Mozilla/5.0" "https://jadwalsholat.org/jadwal-sholat/monthly.php?id=177" \
| grep "<td><b>$(date +%d)</b></td>" \
| sed -E 's/<tr[^>]*>|<\/tr>//g' \
| sed -E 's/<[^>]+>/ /g' \
| awk '{$1=""; print $0}' \
| xargs)

# Bagi ke dalam array
read -ra times <<< "$data"

# Tampilkan dengan format rapi
printf "\nJadwal Sholat Hari Ini (Tanggal %s):\n\n" "$(date +%d-%m-%Y)"
printf "%-8s %-8s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
  "Imsyak" "Subuh" "Terbit" "Dhuha" "Dzuhur" "Ashar" "Maghrib" "Isya"
printf "%-8s %-8s %-8s %-8s %-8s %-8s %-8s %-8s\n" "${times[@]}"
