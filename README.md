## Cloud Storage Benchmarks

This repo contains benchmarks of Infrastructure as a Service (Iaas) disk storage
systems (e.g. AWS's gp2 & io1, Azure's Standard & Premium storage). This repo
does _not_ contain benchmarks of non-disk storage system (e.g. no benchmarks for
Amazon S3 (Simple Cloud Storage Service)).

The benchmarks are catalogued by the benchmarking software, e.g. the newest
benchmarks are stored in the `gobonniego-1.0.9/` directory, benchmarks created
by the [GoBonnieGo](https://github.com/cunnie/gobonniego) filesystem
benchmarking app version 1.0.9.

This repo contains the raw benchmark data. For an interpretation of the data,
please refer to *[Benchmarking the Disk Speed of
IaaSes](http://engineering.pivotal.io/post/gobonniego_results/)* in the Pivotal
Engineering Journal.

The GoBonnieGo results are in JSON, one terribly-long line of JSON. Users may
find it convenient to use a JSON utility such as
[`jq`](https://stedolan.github.io/jq/) to parse the results.

In the following example, we use `jq` to output the IOPS of the ten runs of
GoBonnieGo's benchmark on the Google SSD 256 GiB disk:

```bash
jq -r .results[].iops < gobonniego-1.0.9/gce_pd-ssd-256.json
  8265.912716067336
  8356.497518723809
  8293.375722781182
  ...
```

The other two metrics, read throughput and write throughput, can be emitted by
substituting the word `iops` in the command above with the words
`read_megabytes_per_second` and `write_megabytes_per_second`, respectively.

## Developer Notes

The following command creates three tab-separated value (.tsv) files, one for
each metric (IOPS, read MB/s, write MB/s). Each file has one column for the IaaS/disk combination (e.g. AWS gp2 20 GiB), and each row is the benchmark results for
that metric during that hour. Twenty-four hours of metrics total.

The files are meant to be imported into Google Sheets.

```bash
pushd GoBonnieGo-1.0.9
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  > /tmp/$METRIC.tsv
  for FILE in \
    aws_gp2.json \
    aws_standard.json \
    gce_pd-ssd-256.json \
    gce_pd-ssd.json \
    gce_pd-standard-256.json \
    gce_pd-standard.json \
    vsphere_freenas.json
  do
    (
      echo $FILE;
      # convert `start_time` from date to seconds-elapsed-since-test-suite-began
      jq -r '( .start_time | sub("\\.[0-9]*";"") | fromdate ) as $start_time |
        .results = [ .results[] |
          .start_time = ( .start_time | sub("\\.[0-9]*";"") | fromdate - $start_time )
        ]' < $FILE |
      jq -r " .results[] |
        (.start_time                 | tostring) + \"\t\" +
        (.$METRIC                    | tostring)" |
      ../bin/hourly_collapse.rb
    ) |
      paste /tmp/$METRIC.tsv - > /tmp/$METRIC.$$.tsv
    mv -f /tmp/$METRIC.$$.tsv /tmp/$METRIC.tsv
  done
done
popd
```

To create an-AWS specific metrics into a spreadsheet.

```bash
pushd GoBonnieGo-1.0.9
IAAS=aws
> /tmp/$IAAS.tsv
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in \
    aws_standard.json \
    aws_standard-256.json \
    aws_gp2.json \
    aws_gp2-256.json \
    aws_io1.json
  do
    ( echo $METRIC; echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$IAAS.tsv - > /tmp/$IAAS.$$.tsv
    mv -f /tmp/$IAAS.$$.tsv /tmp/$IAAS.tsv
  done
done
popd
```

Azure metrics:

```bash
pushd GoBonnieGo-1.0.9
IAAS=azure
> /tmp/$IAAS.tsv
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
      paste /tmp/$IAAS.tsv - > /tmp/$IAAS.$$.tsv
    mv -f /tmp/$IAAS.$$.tsv /tmp/$IAAS.tsv
  done
done
popd
```

Google throttle metrics:

```bash
pushd GoBonnieGo-1.0.9
IAAS=google
> /tmp/$IAAS.tsv
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in \
    gce_pd-standard.json \
    gce_pd-standard-2.json
  do
    ( echo $METRIC; echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$IAAS.tsv - > /tmp/$IAAS.$$.tsv
    mv -f /tmp/$IAAS.$$.tsv /tmp/$IAAS.tsv
  done
done
popd
```

AWS throttle metrics:

```bash
pushd GoBonnieGo-1.0.9
IAAS=aws
> /tmp/$IAAS.tsv
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in aws_gp2-lr-0{0,1}.json; do
    ( echo $METRIC; echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$IAAS.tsv - > /tmp/$IAAS.$$.tsv
    mv -f /tmp/$IAAS.$$.tsv /tmp/$IAAS.tsv
  done
done
popd
```

vSphere metrics:

```bash
pushd GoBonnieGo-1.0.9
IAAS=vsphere
> /tmp/$IAAS.tsv
for METRIC in iops read_megabytes_per_second write_megabytes_per_second; do
  for FILE in \
    vsphere_nvme.json \
    vsphere_sata.json \
    gce_pd-ssd-256.json
  do
    ( echo $METRIC; echo $FILE; jq -r .results[].$METRIC < $FILE ) |
      paste /tmp/$IAAS.tsv - > /tmp/$IAAS.$$.tsv
    mv -f /tmp/$IAAS.$$.tsv /tmp/$IAAS.tsv
  done
done
popd
```
