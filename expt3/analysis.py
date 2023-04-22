import os
import sys

# calculate througput per 0.5s
def getThroughput():
    total_bits_tcp = 0
    total_bits_cbr = 0
    last_recorded_time = 0
    time_scale = 0.5
    result = []

    with open("expt3.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            time = float(chunk[1])
            pkt_size = int(chunk[5])
            fid = chunk[7]

            # tcp
            if fid == '1' and event == 'r':
                total_bits_tcp += 8 * pkt_size

            # cbr
            if fid == '2' and event == 'r':
                total_bits_cbr += 8 * pkt_size

            if time - last_recorded_time < time_scale:
                pass
            else:
                througput_tcp = total_bits_tcp / time_scale / (1024 * 1024)
                througput_cbr = total_bits_cbr / time_scale / (1024 * 1024)

                result.append((througput_tcp, througput_cbr))

                total_bits_tcp = 0
                total_bits_cbr = 0
                last_recorded_time += time_scale

    return result

# calculate average latency per 0.5s
def getAverageLatency():
    total_latency = 0
    pkt_amount = 0
    send_time = {}
    arrival_time = {}
    last_recorded_time = 0
    time_scale = 0.5

    result = []

    with open("expt3.tr") as f:
        for line in f:
            chunk = line.split()

            event = chunk[0]
            time = float(chunk[1])
            src = chunk[2]
            des = chunk[3]
            fid = chunk[7]
            seq = chunk[10]

            # tcp
            if fid == '1':
                if event == '+' and src == '0':
                    send_time[seq] = time
                if event == 'r' and des == '0':
                    arrival_time[seq] = time

            if time - last_recorded_time < time_scale:
                pass
            else:
                for seq_num in send_time.keys():
                    if seq_num in arrival_time.keys():
                        duration = arrival_time[seq_num] - send_time[seq_num]
                        if duration > 0:
                            total_latency += duration
                            pkt_amount += 1

                average_latency = (total_latency / pkt_amount) * 1000

                result.append(average_latency)

                total_latency = 0
                pkt_amount = 0
                send_time = {}
                arrival_time = {}
                last_recorded_time += time_scale

    return result


if __name__ == "__main__":
    throughput = getThroughput()
    latency = getAverageLatency()
    start_time = 0

    print("Time(s)\t\tTCP Throughput(Mbps)\tCBR Throughput(Mbps)\tTCP Latency(ms)")

    for i in range(len(throughput)):
        tcp, cbr = throughput[i]
        lat = latency[i]

        print("{:.1f}\t\t{:.2f}\t\t\t{:.2f}\t\t\t{:.2f}".format(start_time, tcp, cbr, lat))

        start_time += 0.5

    os.system("rm *.tr")
