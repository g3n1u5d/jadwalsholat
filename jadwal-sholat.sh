#!/bin/bash

# Lokasi folder tempat skrip ini berada
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tanggal=$(date +%Y-%m-%d)
cache_file="$script_dir/jadwalsholat-$tanggal.html"

# Cek apakah file cache sudah ada
if [ ! -f "$cache_file" ]; then
    echo "update jadwal sholat tanggal $tanggal..."
    curl -s -A "Mozilla/5.0" "https://jadwalsholat.org/jadwal-sholat/monthly.php?id=177" > "$cache_file"
fi

# Ambil data dari file cache
data=$(grep "<td><b>$(date +%d)</b></td>" "$cache_file" \
    | sed -E 's/<tr[^>]*>|<\/tr>//g' \
    | sed -E 's/<[^>]+>/ /g' \
    | awk '{$1=""; print $0}' \
    | xargs)

# Bagi ke dalam array
read -ra times <<< "$data"

# Tampilkan hasil
printf "\nJadwal Sholat Hari Ini (Tanggal %s):\n\n" "$(date +%d-%m-%Y)"
printf "%-8s %-8s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
  "Imsyak" "Subuh" "Terbit" "Dhuha" "Dzuhur" "Ashar" "Maghrib" "Isya"
printf "%-8s %-8s %-8s %-8s %-8s %-8s %-8s %-8s\n" "${times[@]}"
