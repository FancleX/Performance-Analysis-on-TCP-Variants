import os
import sys

# calculate througput
def getThroughput():
    total_bits_tcp1 = 0
    start_time_tcp1 = -0.0
    end_time_tcp1 = 0.0

    total_bits_tcp2 = 0
    start_time_tcp2 = -0.0
    end_time_tcp2 = 0.0

    with open("expt2.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            time = float(chunk[1])
            src = chunk[2]
            pkt_size = int(chunk[5])
            fid = chunk[7]

            # tcp 1
            if fid == '1':
                if event == '+' and src == '0':
                    if start_time_tcp1 == -0.0:
                        start_time_tcp1 = time
                if event == 'r':
                    total_bits_tcp1 += 8 * pkt_size
                    end_time_tcp1 = time
            # tcp 2
            if fid == '2':
                if event == '+' and src == '4':
                    if start_time_tcp2 == -0.0:
                        start_time_tcp2 = time
                if event == 'r':
                    total_bits_tcp2 += 8 * pkt_size
                    end_time_tcp2 = time


    duration_tcp1 = end_time_tcp1 - start_time_tcp1
    througput_tcp1 = total_bits_tcp1 / duration_tcp1 / (1024 * 1024)

    duration_tcp2 = end_time_tcp2 - start_time_tcp2
    througput_tcp2 = total_bits_tcp2 / duration_tcp2 / (1024 * 1024)

    return througput_tcp1, througput_tcp2

# calculate packet frop rate
def getPktDropRate():
    total_pkt_sent_tcp1 = 0
    dropped_pkt_tcp1 = 0

    total_pkt_sent_tcp2 = 0
    dropped_pkt_tcp2 = 0

    with open("expt2.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            fid = chunk[7]

            # tcp 1
            if fid == '1':
                if event == '+':
                    total_pkt_sent_tcp1 += 1
                if event == 'd':
                    dropped_pkt_tcp1 += 1

            # tcp 2
            if fid == '2':
                if event == '+':
                    total_pkt_sent_tcp2 += 1
                if event == 'd':
                    dropped_pkt_tcp2 += 1

    pkt_drop_rate_tcp1 = (float(dropped_pkt_tcp1) / float(total_pkt_sent_tcp1)) * 100
    pkt_drop_rate_tcp2 = (float(dropped_pkt_tcp2) / float(total_pkt_sent_tcp2)) * 100

    return pkt_drop_rate_tcp1, pkt_drop_rate_tcp2

# calculate average latency
def getAverageLatency():
    total_latency_tcp1 = 0
    pkt_amount_tcp1 = 0
    send_time_tcp1 = {}
    arrival_time_tcp1 = {}

    total_latency_tcp2 = 0
    pkt_amount_tcp2 = 0
    send_time_tcp2 = {}
    arrival_time_tcp2 = {}

    with open("expt2.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            time = float(chunk[1])
            src = chunk[2]
            des = chunk[3]
            fid = chunk[7]
            seq = chunk[10]

            # tcp 1
            if fid == '1':
                if event == '+' and src == '0':
                    send_time_tcp1[seq] = time
                if event == 'r' and des == '0':
                    arrival_time_tcp1[seq] = time
            # tcp 2
            if fid == '2':
                if event == '+' and src == '4':
                    send_time_tcp2[seq] = time
                if event == 'r' and des == '4':
                    arrival_time_tcp2[seq] = time

    # tcp 1
    for seq_num in send_time_tcp1.keys():
        if seq_num in arrival_time_tcp1.keys():
            duration_tcp1 = arrival_time_tcp1[seq_num] - send_time_tcp1[seq_num]
            if duration_tcp1 > 0:
                total_latency_tcp1 += duration_tcp1
                pkt_amount_tcp1 += 1

    # tcp 2
    for seq_num in send_time_tcp2.keys():
        if seq_num in arrival_time_tcp2.keys():
            duration_tcp2 = arrival_time_tcp2[seq_num] - send_time_tcp2[seq_num]
            if duration_tcp2 > 0:
                total_latency_tcp2 += duration_tcp2
                pkt_amount_tcp2 += 1

    average_latency_tcp1 = (total_latency_tcp1 / pkt_amount_tcp1) * 1000
    average_latency_tcp2 = (total_latency_tcp2 / pkt_amount_tcp2) * 1000

    return average_latency_tcp1, average_latency_tcp2

if __name__ == "__main__":
    cbr_rate = sys.argv[1]

    througput1, througput2 = getThroughput()
    latency1, latency2 = getAverageLatency()
    drop_rate1, drop_rate2 = getPktDropRate()

    print("{:s}\t    {:.2f}\t{:.2f}\t{:.2f}\t{:.2f}\t{:.2f}\t{:.2f}".format(cbr_rate, througput1, througput2, latency1, latency2, drop_rate1, drop_rate2))

    os.system("rm *.tr")
