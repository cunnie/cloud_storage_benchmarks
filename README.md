Various Benchmarks using `bonnie++`

To figure out the average

```
grep '^[0-9.]' NVMe_80G.txt | awk -F, -f stats.awk
```
