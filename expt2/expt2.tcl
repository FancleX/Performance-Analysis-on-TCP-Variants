proc expt1 {cbr_rate tcp_variant1 tcp_variant2} {
        global ns tf
        # create a simulator object
        set ns [new Simulator]

        # save data to a file
        set tf [open expt2.tr w]
        $ns trace-all $tf

        # finish procedure function
        proc finish {} {
                global ns tf
                $ns flush-trace
                # Close the trace file
                close $tf
                exit 0
        }

        # create 6 nodes
        set n1 [$ns node]
        set n2 [$ns node]
        set n3 [$ns node]
        set n4 [$ns node]
        set n5 [$ns node]
        set n6 [$ns node]

        # create 5 links
        $ns duplex-link $n1 $n2 10Mb 10ms DropTail
        $ns duplex-link $n5 $n2 10Mb 10ms DropTail
        $ns duplex-link $n2 $n3 10Mb 10ms DropTail
        $ns duplex-link $n3 $n4 10Mb 10ms DropTail
        $ns duplex-link $n3 $n6 10Mb 10ms DropTail

        # set queue size limit
        $ns queue-limit $n2 $n3 10

        # set tcp from n1 to n4
        # set tcp source
        set tcp1 [new Agent/TCP/$tcp_variant1]
        $ns attach-agent $n1 $tcp1
        #set tcp sink
        set sink1 [new Agent/TCPSink]
        $ns attach-agent $n4 $sink1
        # setup connection
        $ns connect $tcp1 $sink1
        $tcp1 set fid_ 1
        # setup a FTP over the TCP connection
        set ftp1 [new Application/FTP]
        $ftp1 attach-agent $tcp1
        $ftp1 set type_ FTP

        # set tcp from n5 to n6
        # set tcp source
        set tcp2 [new Agent/TCP/$tcp_variant2]
        $ns attach-agent $n5 $tcp2
        #set tcp sink
        set sink2 [new Agent/TCPSink]
        $ns attach-agent $n6 $sink2
        # setup connection
        $ns connect $tcp2 $sink2
        $tcp2 set fid_ 2
        # setup a FTP over the TCP connection
        set ftp2 [new Application/FTP]
        $ftp2 attach-agent $tcp2
        $ftp2 set type_ FTP

        # set udp from n2 to n3
        # set udp source
        set udp [new Agent/UDP]
        $ns attach-agent $n2 $udp
        # set udp sink
        set null [new Agent/Null]
        $ns attach-agent $n3 $null
        # set udp flow direction
        $ns connect $udp $null
        $udp set fid_ 3
        # setup CBR over UDP
        set cbr [new Application/Traffic/CBR]
        $cbr attach-agent $udp
        $cbr set type_ CBR
        $cbr set packet_size_ 1000
        $cbr set rate_ ${cbr_rate}mb
        $cbr set random_ false

        # schedule events for the CBR and FTP agents
        $ns at 0.1 "$cbr start"
        $ns at 1.0 "$ftp1 start"
        $ns at 1.0 "$ftp2 start"
        $ns at 6.0 "$ftp2 stop"
        $ns at 6.0 "$ftp1 stop"
        $ns at 6.5 "$cbr stop"

        # call the finish procedure after 7s simulation
        $ns at 7.0 "finish"

        $ns run
}

# pass parameters
expt1 [lindex $argv 0] [lindex $argv 1] [lindex $argv 2]
