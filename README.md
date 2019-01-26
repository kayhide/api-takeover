# api-takeover

This follows the blog post [Incremental API Takeover with Haskell Servant](https://www.parsonsmatt.org/2016/06/24/take_over_an_api_with_servant.html).

Using the updated version of servant-0.15.



## Benchmark


```
% make benchmark
*** Requesting to the old server

httperf --port=4567 --num-calls=500 --uri=/
httperf --client=0/1 --server=localhost --port=4567 --uri=/ --send-buffer=4096 --recv-buffer=16384 --num-conns=1 --num-calls=500
httperf: warning: open file limit > FD_SETSIZE; limiting max. # of open files to FD_SETSIZE
Maximum connect burst length: 0

Total: connections 1 requests 500 replies 500 test-duration 0.249 s

Connection rate: 4.0 conn/s (248.6 ms/conn, <=1 concurrent connections)
Connection time [ms]: min 248.6 avg 248.6 max 248.6 median 248.5 stddev 0.0
Connection time [ms]: connect 0.3
Connection length [replies/conn]: 500.000

Request rate: 2010.9 req/s (0.5 ms/req)
Request size [B]: 62.0

Reply rate [replies/s]: min 0.0 avg 0.0 max 0.0 stddev 0.0 (0 samples)
Reply time [ms]: response 0.5 transfer 0.0
Reply size [B]: header 173.0 content 69.0 footer 0.0 (total 242.0)
Reply status: 1xx=0 2xx=500 3xx=0 4xx=0 5xx=0

CPU time [s]: user 0.07 system 0.18 (user 27.1% system 72.4% total 99.6%)
Net I/O: 597.0 KB/s (4.9*10^6 bps)

Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0

*** Requesting to the new server

httperf --port=8080 --num-calls=500 --uri=/
httperf --client=0/1 --server=localhost --port=8080 --uri=/ --send-buffer=4096 --recv-buffer=16384 --num-conns=1 --num-calls=500
httperf: warning: open file limit > FD_SETSIZE; limiting max. # of open files to FD_SETSIZE
Maximum connect burst length: 0

Total: connections 1 requests 500 replies 500 test-duration 0.034 s

Connection rate: 29.3 conn/s (34.2 ms/conn, <=1 concurrent connections)
Connection time [ms]: min 34.2 avg 34.2 max 34.2 median 34.5 stddev 0.0
Connection time [ms]: connect 0.3
Connection length [replies/conn]: 500.000

Request rate: 14631.0 req/s (0.1 ms/req)
Request size [B]: 62.0

Reply rate [replies/s]: min 0.0 avg 0.0 max 0.0 stddev 0.0 (0 samples)
Reply time [ms]: response 0.1 transfer 0.0
Reply size [B]: header 144.0 content 77.0 footer 2.0 (total 223.0)
Reply status: 1xx=0 2xx=500 3xx=0 4xx=0 5xx=0

CPU time [s]: user 0.01 system 0.03 (user 26.4% system 73.3% total 99.7%)
Net I/O: 4043.5 KB/s (33.1*10^6 bps)

Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0
```

It shows about 2000 req/s on the sinatra server, 14000 req/s on the servant server.

About 7 times faster.
