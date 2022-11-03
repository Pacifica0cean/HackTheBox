## Taken from the RTFM book.

for x in {1..254..1};do ping -c 1 X.X.X.$x |grep "64 b" |cut -d" " -f4 >> ips.txt; done
