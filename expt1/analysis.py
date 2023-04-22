import os
import sys

# calculate througput
def getThroughput():
    total_bits = 0
    start_time = -0.0
    end_time = 0.0

    with open("expt1.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            time = float(chunk[1])
            src = chunk[2]
            pkt_size = int(chunk[5])
            fid = chunk[7]

            # tcp
            if fid == '1':
                if event == '+' and src == '0':
                    if start_time == -0.0:
                        start_time = time
                if event == 'r':
                    total_bits += 8 * pkt_size
                    end_time = time

    duration = end_time - start_time
    througput = total_bits / duration / (1024 * 1024)

    return througput

# calculate packet frop rate
def getPktDropRate():
    total_pkt_sent = 0
    dropped_pkt = 0

    with open("expt1.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            fid = chunk[7]

            if fid == '1':
                if event == '+':
                    total_pkt_sent += 1
                if event == 'd':
                    dropped_pkt += 1

    pkt_drop_rate = (float(dropped_pkt) / float(total_pkt_sent)) * 100

    return pkt_drop_rate

# calculate average latency
def getAverageLatency():
    total_latency = 0
    pkt_amount = 0
    send_time = {}
    arrival_time = {}

    with open("expt1.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            time = float(chunk[1])
            src = chunk[2]
            des = chunk[3]
            fid = chunk[7]
            seq = chunk[10]

            if fid == '1':
                if event == '+' and src == '0':
                    send_time[seq] = time
                if event == 'r' and des == '0':
                    arrival_time[seq] = time

    for seq_num in send_time.keys():
        if seq_num in arrival_time.keys():
            duration = arrival_time[seq_num] - send_time[seq_num]
            if duration > 0:
                total_latency += duration
                pkt_amount += 1

    average_latency = (total_latency / pkt_amount) * 1000

    return average_latency

if __name__ == "__main__":
    cbr_rate = sys.argv[1]

    througput = getThroughput()
    latency = getAverageLatency()
    drop_rate = getPktDropRate()

    print("{:s}\t      {:.2f}\t\t  {:.2f}\t\t{:.2f}".format(cbr_rate, througput, latency, drop_rate))

    os.system("rm *.tr")
