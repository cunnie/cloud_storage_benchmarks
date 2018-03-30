Various Benchmarks using GoBonnieGo and bonnie++.

To copy the GoBonnieGo metrics into a spreadsheet for further consumption:

```
pushd GoBonnieGo-1.0.7
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  > /tmp/$METRIC.csv
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
    ( echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$METRIC.csv - > /tmp/$METRIC.$$.csv
    mv -f /tmp/$METRIC.$$.csv /tmp/$METRIC.csv
  done
done
popd
```
To create an-AWS specific metrics into a spreadsheet.
```
pushd GoBonnieGo-1.0.7
IAAS=aws
> /tmp/$IAAS.csv
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in \
    aws_standard.json \
    aws_standard-256.json \
    aws_gp2.json \
    aws_gp2-256.json \
    aws_io1.json
  do
    ( echo $METRIC; echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$IAAS.csv - > /tmp/$IAAS.$$.csv
    mv -f /tmp/$IAAS.$$.csv /tmp/$IAAS.csv
  done
done
popd
```
Azure metrics:
```
pushd GoBonnieGo-1.0.7
IAAS=azure
> /tmp/$IAAS.csv
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in \
    azure_standard_lrs.json \
    azure_standard_lrs-rw.json \
    azure_standard_lrs-256.json \
    azure_premium_lrs.json \
    azure_premium_lrs-256.json \
    azure_premium_lrs-256-rw.json
  do
    ( echo $METRIC; echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$IAAS.csv - > /tmp/$IAAS.$$.csv
    mv -f /tmp/$IAAS.$$.csv /tmp/$IAAS.csv
  done
done
popd
```
Google metrics:
```
pushd GoBonnieGo-1.0.7
IAAS=google
> /tmp/$IAAS.csv
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in \
    gce_pd-standard.json \
    gce_pd-standard-2.json
  do
    ( echo $METRIC; echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$IAAS.csv - > /tmp/$IAAS.$$.csv
    mv -f /tmp/$IAAS.$$.csv /tmp/$IAAS.csv
  done
done
popd
```
