# bash scipt to run simulation with paratmeters

crb_rate=8

echo "==================== simulation start ===================="

echo "-------------------- Reno/DropTail --------------------"
/course/cs4700f12/ns-allinone-2.35/bin/ns expt3.tcl $crb_rate Reno DropTail
python analysis.py


echo "-------------------- Reno/RED --------------------"
/course/cs4700f12/ns-allinone-2.35/bin/ns expt3.tcl $crb_rate Reno RED
python analysis.py

echo "-------------------- Sack/DropTail --------------------"

/course/cs4700f12/ns-allinone-2.35/bin/ns expt3.tcl $crb_rate Sack DropTail
python analysis.py

echo "-------------------- Sack/RED --------------------"
/course/cs4700f12/ns-allinone-2.35/bin/ns expt3.tcl $crb_rate Sack RED
python analysis.py
