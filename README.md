Various Benchmarks using GoBonnieGo and bonnie++.

To copy the GoBonnieGo metrics into a spreadsheet for further consumption:

```
cd GoBonnieGo-1.0.7
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in \
    aws_gp2.json \
    aws_io1.json \
    aws_standard.json \
    azure_premium_lrs-256-rw.json \
    azure_standard_lrs-rw.json \
    gce_pd-ssd-256.json \
    gce_pd-ssd.json \
    gce_pd-standard-256.json \
    gce_pd-standard.json \
    vsphere_freenas.json
  do
    echo $FILE
    jq -r .results[].$METRIC < $FILE | pbcopy
    read A
  done
  read B
done
```

Note that we don't choose _all_ the metrics — we don't want to overwhelm the
reader with too much information; instead, we want to select the metrics that
are particularly significant.

To create a .csv file containing the benchmarks:

```
echo ",\"IOPS\",\"Read\",\"Write\"" > /tmp/junk.csv
for file in *80G.txt; do
  echo -n "\"$file\"," >> /tmp/junk.csv
  grep '^[0-9.]' $file  | awk -F, -f stats.awk >> /tmp/junk.csv
done
```
