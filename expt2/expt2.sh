# bash scipt to run simulation with paratmeters

crb_rate=(1 2 3 4 5 6 7 8 9 10)

echo "==================== simulation start ===================="

echo "-------------------- Reno/Reno --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
echo "             T1         T2       L1     L2      P1        P2"
for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt2.tcl $i Reno Reno
python analysis.py $i
done

echo "-------------------- NewReno/Reno --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
echo "             T1       T2         L1   L2        P1        P2"
for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt2.tcl $i Newreno Reno
python analysis.py $i
done

echo "-------------------- Vegas/Vegas --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
echo "             T1       T2         L1   L2        P1        P2"
for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt2.tcl $i Vegas Vegas
python analysis.py $i
done

echo "-------------------- NewReno/Vegas --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
echo "             T1       T2         L1   L2        P1        P2"
for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt2.tcl $i Newreno Vegas
python analysis.py $i
done
