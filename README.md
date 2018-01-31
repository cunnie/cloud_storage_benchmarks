Various Benchmarks using `bonnie++`

To create a .csv file containing the benchmarks:

```
echo ",\"IOPS\",\"Read\",\"Write\"" > /tmp/junk.csv
for file in *80G.txt; do
  echo -n "\"$file\"," >> /tmp/junk.csv
  grep '^[0-9.]' $file  | awk -F, -f stats.awk >> /tmp/junk.csv
done
```
