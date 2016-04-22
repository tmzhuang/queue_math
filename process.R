#!/usr/bin/env Rscript
require('plotrix')
data = read.csv("arrival_service_times.csv")
rs = read.csv("interarrival.csv")
s1 = data[,'s1']
s2 = data[,'s2']
r = rs[,'r']
png('interarrival.png')
h_r = hist(r, freq = FALSE)
png('service1.png')
h_s1 = hist(s1, freq = FALSE)
png('service2.png')
h_s2 = hist(s2, freq = FALSE)
dev.off()
