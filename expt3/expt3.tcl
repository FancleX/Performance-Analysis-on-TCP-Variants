proc expt1 {cbr_rate tcp_varaint queue_type} {
        global ns tf
        # create a simulator object
        set ns [new Simulator]

        # save data to a file
        set tf [open expt3.tr w]
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
        $ns duplex-link $n1 $n2 10Mb 10ms $queue_type
        $ns duplex-link $n5 $n2 10Mb 10ms $queue_type
        $ns duplex-link $n2 $n3 10Mb 10ms $queue_type
        $ns duplex-link $n3 $n4 10Mb 10ms $queue_type
        $ns duplex-link $n3 $n6 10Mb 10ms $queue_type
        # set queue size limit
        $ns queue-limit $n1 $n2 10
        $ns queue-limit $n5 $n2 10
        $ns queue-limit $n2 $n3 10
        $ns queue-limit $n3 $n4 10
        $ns queue-limit $n3 $n6 10

        # set tcp from n1 to n4
        # set tcp source and sink
        if {$tcp_varaint == "Sack"} {
                set tcp [new Agent/TCP/Sack1]
                set sink [new Agent/TCPSink/Sack1]
        } else {
                set tcp [new Agent/TCP/Reno]
                set sink [new Agent/TCPSink]
        }
        $ns attach-agent $n1 $tcp
        $ns attach-agent $n4 $sink
        # setup connection
        $ns connect $tcp $sink
        $tcp set fid_ 1
        # setup a FTP over the TCP connection
        set ftp [new Application/FTP]
        $ftp attach-agent $tcp
        $ftp set type_ FTP

        # set udp from n5 to n6
        # set udp source
        set udp [new Agent/UDP]
        $ns attach-agent $n5 $udp
        # set udp sink
        set null [new Agent/Null]
        $ns attach-agent $n6 $null
        # set udp flow direction
        $ns connect $udp $null
        $udp set fid_ 2
        # setup CBR over UDP
        set cbr [new Application/Traffic/CBR]
        $cbr attach-agent $udp
        $cbr set type_ CBR
        $cbr set packet_size_ 1000
        $cbr set rate_ ${cbr_rate}mb
        $cbr set random_ false

        # schedule events for the CBR and FTP agents
        $ns at 0.0 "$ftp start"
        $ns at 2.0 "$cbr start"
        $ns at 10.0 "$cbr stop"
        $ns at 10.0 "$ftp stop"

        # call the finish procedure after 10s simulation
        $ns at 10.0 "finish"

        $ns run
}

# pass parameters
expt1 [lindex $argv 0] [lindex $argv 1] [lindex $argv 2]
