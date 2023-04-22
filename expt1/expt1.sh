# bash scipt to run simulation with paratmeters

crb_rate=(1 2 3 4 5 6 7 8 9 10)

echo "==================== simulation start ===================="
echo "-------------------- Tahoe --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"

for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt1.tcl $i Tahoe
python analysis.py $i
done

echo "-------------------- Reno --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt1.tcl $i Reno
python analysis.py $i
done

echo "-------------------- NewReno --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt1.tcl $i Newreno
python analysis.py $i
done

echo "-------------------- Vegas --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}
do
/course/cs4700f12/ns-allinone-2.35/bin/ns expt1.tcl $i Vegas
python analysis.py $i
done
