### Experiment 1: TCP Performance Under Congestion
In the first set of experiments, you will analyze the performance of TCP variants (Tahoe, Reno,
NewReno, and Vegas) under the influence of various load conditions. To study the behavior of
the four TCP variants, you need to first set up a network topology. Use the following topology for
your experiments, and set the bandwidth of each link to 10Mbps:

```
N1 						  N4
  \ 					  /
   \ 		   			 /
	N2-----------------N3
	/                   \
   /                     \
 N5                       N6
```

Using this topology, you will perform tests that analyze the performance of different TCP
variants in the presence of a Constant Bit Rate (CBR) flow. You can think of the CBR flow as an
unresponsive UDP flow: it uses a specific amount of bandwidth, it does not care about dropped
packets, and it does not perform congestion control. Basically, it just sends packets blindly at a
constant rate.

Add a CBR source at N2 and a sink at N3, then add a single TCP stream from N1 to a sink at
N4. Analyze the throughput, packet drop rate, and latency of the TCP stream as a function of
the bandwidth used by the CBR flow. That is, the bandwidth of the CBR flow is the parameter
you need to vary for this experiment. For example, start the CBR flow at a rate of 1 Mbps and
record the performance of the TCP flow. Then change the CBR flow's rate to 2 Mbps and
perform the test again. Keep changing the CBR's rate until it reaches the bottleneck capacity.
The TCP stream's performance will change depending on the amount of contention with the
CBR flow. Conduct this experiment using the following TCP variants: Tahoe, Reno, NewReno,
and Vegas.

Based on the results from your tests you should be able to answer the following questions:

- which TCP variant(s) are able to get higher average throughput? 
- Which has the lowest average latency? 
- Which has the fewest drops? Is there an overall "best" TCP variant in this experiment, or does the "best" variant vary depending on other circumstances?

### Experiment 2: Fairness Between TCP Variants
Next, you will conduct experiments to analyze the fairness between different TCP variants. Out
on the Internet, there are many different operating systems, each of which may use a different
variant of TCP. Ideally, all of these variants should be fair to one another, i.e. no particular
variant gets more bandwidth than the others. However, is this ideal assumption true?
For these experiments, you will start three flows: one CBR, and two TCP. Add a CBR source at
N2 and a sink at N3, then add two TCP streams from N1 to N4 and N5 to N6, respectively. As in
Experiment 1, plot the average throughput, packet loss rate, and latency of each TCP flow as a
function of the bandwidth used by the CBR flow. Repeat the experiments using the following
pairs of TCP variants (i.e. with one flow from N1 to N4, and the other flow from N5 to N6):

- Reno/Reno
- NewReno/Reno
- Vegas/Vegas
- NewReno/Vegas

Based on your results you should be able to answer the following questions: 

- are the different combinations of variants fair to each other? 
- Are there combinations that are unfair, and if so, why is the combination unfair? To explain unfairness, you will need to think critically about how the protocols are implemented and why the different choices in different TCP variants can impact fairness.

### Experiment 3: Influence of Queuing
Queuing disciplines like DropTail and Random Early Drop (RED) are algorithms that control how
packets in a queue are treated. In these experiments, instead of varying the rate of the CBR
flow, you will study the influence of the queuing discipline used by nodes on the overall
throughput of flows.

Use the same topology from experiment 1 and have one TCP flow (N1-N4) and one CBR/UDP
(N5-N6) flow. First, start the TCP flow. Once the TCP flow is steady, start the CBR source and
analyze how the TCP and CBR flows change under the following queuing algorithms: DropTail
and RED. Perform the experiments with TCP Reno and SACK. In these tests, you will need to
plot the performance of the TCP and CBR flow over time (i.e. you are no longer varying the
bandwidth of the CBR flow).

Based on the results of these experiments, you should be able to answer the following
questions:

- Does each queuing discipline provide fair bandwidth to each flow?
- How does the end-to-end latency for the flows differ between DropTail and RED?
- How does the TCP flow react to the creation of the CBR flow?
- Is RED a good idea while dealing with SACK?