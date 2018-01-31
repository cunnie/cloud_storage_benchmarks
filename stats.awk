# grep '^[0-9.]' NVMe_80G.txt | awk -F, -f stats.awk
# averages: print write & read in MiB (kiB / 1024) and IOPS
    { write += $10; read += $16; IOPS += $18; nlines++ }
END { print IOPS/nlines "," read/nlines/1024 "," write/nlines/1024 "," }
