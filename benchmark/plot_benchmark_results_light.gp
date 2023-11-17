# Set terminal and output file for light theme
set terminal pngcairo size 1920,720 enhanced
set output 'benchmark-plot-light.png'

# Set background color to light theme
set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb "#ffffff" behind

# Set title and labels
set title 'Benchmark Results (iPhone 13 - 720p - H265)' textcolor rgb "#000000"
set xlabel 'Time (s)' textcolor rgb "#000000"
set ylabel 'Latency (ms)' textcolor rgb "#000000"

# Define the data file and separator
datafile = 'benchmark.txt'
separator = ' '

# Define the columns to be used for plotting
col_time = 1
col_latency = 2
col_bitrate = 3
col_jitter = 4
col_bytes_sent = 5
col_packets_lost = 6
col_encode_time = 7

# Automatically adjust the x-axis tics
set xtics auto

# Set grid lines
set grid linecolor rgb "#000000" lw 0.5

# Set line color and style for latency
set style line 1 lc rgb "#1f77b4" lw 2

# Set line color and style for bitrate
set style line 2 lc rgb "#ff7f0e" lw 2

# Set line color and style for jitter
set style line 3 lc rgb "#2ca02c" lw 2

# Set line color and style for bytesSent
set style line 4 lc rgb "#d62728" lw 2

# Set border line color
set border linecolor rgb "#000000"

# Set zero line color
set zeroaxis linecolor rgb "#000000"

# Set title font
set title font ",14" tc rgb "#000000"

# Set label font
set xlabel font ",12" tc rgb "#000000"
set ylabel font ",12" tc rgb "#000000"

# Set tics font
set xtics font ",10" tc rgb "#000000"
set ytics font ",10" tc rgb "#000000"

# Set semi-transparent fill color for the plot area
set style fill transparent solid 0.5 noborder

# Set legend text color
set key textcolor rgb "#000000"

# Plot the data with multiple axes
plot datafile using col_time:col_latency with lines title 'Latency' linestyle 1, \
     datafile using col_time:col_bitrate axis x1y2 with lines title 'Bitrate (Mbps)' linestyle 2, \
     datafile using col_time:col_jitter axis x1y2 with lines title 'Jitter (s)' linestyle 3, \
     datafile using col_time:col_bytes_sent axis x1y2 with lines title 'Bytes Sent (MB)' linestyle 4
