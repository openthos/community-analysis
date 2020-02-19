[参考链接](https://01.org/blogs/jdu1/2017/lkp-tests-linux-kernel-performance-test-and-analysis-tool) <br>
# 3   Use lkp-tests Tool
3.1   Setup Environment 

The lkp-tests source code can be downloaded from: https://github.com/01org/lkp-tests. It supports these OS distributions: Debian*, Ubuntu*, CentOS*, Archlinux*, and Oracle* Linux*.

The steps to setup the environment are shown below.

Step 1: Pre-install the required tools for lkp-tests.

# apt-get install git

Step 2: Clone the lkp-tests repo to your local directory.

# git clone https://github.com/01org/lkp-tests.git

Step 3: Go to your lkp-tests installation directory.

# cd lkp-tests (Or to your installation directory)

Step 4: Create a soft link for the lkp command to make it easy to use.

# make install

Step 5: Install basic software packages before running lkp-tests.

# lkp install

3.2   Use the Benchmark/Test Suites in lkp-tests

lkp-tests can be easily used for benchmark installation, benchmark execution, and performance regression profiling.
3.2.1   Benchmark Installation

Step 1: Go to your lkp-tests installation directory.

# cd lkp-tests (Or to your installation directory)

Step 2: Select your desired benchmark (e.g. ebizzy) in the “jobs/” directory to install.

# lkp install jobs/ebizzy.yaml

3.2.2   Run the Benchmark

Step 1: Split a jobfile, e.g. ebizzy.yaml (ignore this step if you want to run all the sub-jobs under ebizzy).

#lkp split jobs/ebizzy.yaml

jobs/ebizzy.yaml => ./ebizzy-200%-100x-10s.yaml

Step 2: Run the benchmark (e.g. ebizzy).

# lkp run  ebizzy-200%-100x-10s.yaml

Sample result:

Iteration: 1
2017-09-07 15:19:03 ./ebizzy -t 32 -S 10
257405 records/s 7762 8072 7682 7476 8713 8234 8401 8992 8467 8030 7482 8356 7721 9148 7721 7776 7870 7554 8389 7707 7524 7844 7692 7168 8479 8288 7632 7724 8534 8969 7722 8262
real 10.00 s
user 157.88 s
sys   0.03 s
...

Notes:

●     The first step helps to split multiple sub-jobs in a jobfile (see section 4.3 for details), and if you want to run all the sub-jobs, please skip the first step and run the jobfile directly like lkp run jobs/ebizzy.yaml .

●     All the statistics data can be found under your result root directory, such as: /result/ebizzy/200%-100x-10s/kemi-desktop/ubuntu/x86_64-rhel-7.2/gcc-6/4.13.0-rc5
3.2.3   Performance Regression Profiling

The lkp ncompare command is very useful to help profile benchmark output results between two different commit IDs, and find out the potential performance regression.

Usage: lkp ncompare -s commit=<parent> -o commit=<commit>.

For example:

# lkp ncompare -s commit=9e66317d3c92ddaab330c125dfe9d06eee268aff -o commit=a11c3148ba6b8b4cac4876b7269d570260d0bd41

Here is the sample output:

compiler/cpufreq_governor/disk/fs/kconfig/load/rootfs/tbox_group/test/testcase:
  gcc-6/performance/1BRD_48G/ext4/x86_64-rhel-7.2/1000/debian-x86_64-2016-08-31.cgz/lkp-bdw-ep2/creat-clo/aim7

commit:
  v4.14-rc3
  a11c3148ba6b8b4cac4876b7269d570260d0bd41

       v4.14-rc3 a11c3148ba6b8b4cac4876b726
---------------- --------------------------
       fail:runs  %reproduction  fail:runs
           |                |                   |   
          2:4          -50%            :4     kmsg.DHCP/BOOTP:Ignoring_fragmented_reply
           :4           25%           1:4     kmsg.DHCP/BOOTP:Reply_not_for_us_on_eth#,op[#]xid[#]
    %stddev     %change      %stddev
           \                  |                \ 
     15431            +3.3%      15936        aim7.jobs-per-min
    388.97            -3.2%     376.67        aim7.time.elapsed_time
    388.97            -3.2%     376.67        aim7.time.elapsed_time.max
     32157            -3.3%      31090        aim7.time.system_time
      0.07 ±  7%      +0.0        0.08 ±  5%  mpstat.cpu.iowait%
     36021           -28.5%      25771 ± 15%  softirqs.NET_RX
    230.15            -1.1%     227.55        turbostat.PkgWatt
      7125            +2.8%       7327        vmstat.system.cs
    560.00 ± 61%     -66.1%     189.75 ± 11%  numa-meminfo.node1.Mlocked
    560.00 ± 61%     -66.1%     189.75 ± 11%  numa-meminfo.node1.Unevictable
    139.50 ± 61%     -65.9%      47.50 ± 10%  numa-vmstat.node1.nr_mlock
    139.50 ± 61%     -65.9%      47.50 ± 10%  numa-vmstat.node1.nr_unevictable
    139.50 ± 61%     -65.9%      47.50 ± 10%  numa-vmstat.node1.nr_zone_unevictable
    370.58 ±  7%     +21.6%     450.44 ±  8%  sched_debug.cfs_rq:/.exec_clock.stddev
      2267 ± 75%    +107.6%       4706 ± 24%  sched_debug.cfs_rq:/.load.min
    …..
