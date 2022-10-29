# FortiGate Private VDOM간 IPSec VPN 구성
![Diagram](./img/diagram.png "Diagram")

## 1. 한국 FortiGate 장비 설정
### VDOM-KO (1번째 VDOM, root)
- AWS와 IPsec VPN 연결 후 BGP 연동
- Route to AWS(BGP): tunnel_1 ip, tunnel_2 ip, VDOM Link Interface (TEST0)
  - 169.254.30.2/32, 169.254.31.2/32, 192.168.30.0/30
- Route from AWS(BGP): 미국 FortiGate 장비 tunnel_1 ip, tunnel_2, ip, VDOM Link Interface(TEST20)
  - 169.254.40.2/32, 169.254.41.2/32, 192.168.40.0/30
```
FG60E (root) # get router info routing-table all
C       169.254.30.1/32 is directly connected, aws-ko-site
C       169.254.30.2/32 is directly connected, aws-ko-site
C       169.254.31.1/32 is directly connected, aws-ko-site2
C       169.254.31.2/32 is directly connected, aws-ko-site2
B       169.254.40.2/32 [150/100] via 169.254.30.1, aws-ko-site, 00:38:26
                        [150/100] via 169.254.31.1, aws-ko-site2, 00:38:26
B       169.254.41.2/32 [150/100] via 169.254.30.1, aws-ko-site, 00:38:26
                        [150/100] via 169.254.31.1, aws-ko-site2, 00:38:26
C       192.168.30.0/30 is directly connected, TEST0
B       192.168.40.0/30 [150/100] via 169.254.30.1, aws-ko-site, 00:38:26
                        [150/100] via 169.254.31.1, aws-ko-site2, 00:38:26
                        
FG60E (root) # execute ping 192.168.40.1
PING 192.168.40.1 (192.168.40.1): 56 data bytes
64 bytes from 192.168.40.1: icmp_seq=0 ttl=250 time=371.5 ms
64 bytes from 192.168.40.1: icmp_seq=1 ttl=250 time=369.4 ms
64 bytes from 192.168.40.1: icmp_seq=2 ttl=250 time=369.3 ms
64 bytes from 192.168.40.1: icmp_seq=3 ttl=250 time=369.6 ms
64 bytes from 192.168.40.1: icmp_seq=4 ttl=250 time=369.4 ms

--- 192.168.40.1 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 369.3/369.8/371.5 ms
```
### AWS 한국리전 Transit Gateway 라우팅 정보
![Routes](./img/aws-ko-tgw-routes.png "AWS-KO TGW Routing")


### VDOM-KOsite (2번째 VDOM)
- TEST1 인터페이스 IP로 미국 FortiGate 장비의 VDOM-USsite VDOM과 IPsec VPN 연결
- IPsec VPN 연결 후 static routing 설정
- Route to 미국: Loopback30 (내부 네트워크)
- Route from 미국: Loopback40 (내부 네트워크)
```
FG60E (VDOM-KOsite) # get router info routing-table all
C       169.254.34.1/32 is directly connected, us-site-vpn
C       169.254.34.2/32 is directly connected, us-site-vpn
C       192.168.30.0/30 is directly connected, TEST1
C       192.168.31.0/24 is directly connected, loopback30
S       192.168.40.2/32 [10/0] via 192.168.30.1, TEST1
S       192.168.41.0/24 [10/0] via 169.254.34.1, us-site-vpn

FG60E (VDOM-KOsite) # execute ping 192.168.41.1
PING 192.168.41.1 (192.168.41.1): 56 data bytes
64 bytes from 192.168.41.1: icmp_seq=0 ttl=255 time=374.6 ms
64 bytes from 192.168.41.1: icmp_seq=1 ttl=255 time=372.7 ms
64 bytes from 192.168.41.1: icmp_seq=2 ttl=255 time=372.5 ms
64 bytes from 192.168.41.1: icmp_seq=3 ttl=255 time=372.5 ms
64 bytes from 192.168.41.1: icmp_seq=4 ttl=255 time=372.8 ms

--- 192.168.41.1 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 372.5/373.0/374.6 ms
```

## 2. 미국 FortiGate 장비 설정
### VDOM-US (1번째 VDOM, root)
- AWS와 IPsec VPN 연결 후 BGP 연동
- Route to AWS: tunnel_1 ip, tunnel_2 ip, VDOM Link Interface (TEST20)
- Route from AWS: 한국 FortiGate 장비 tunnel_1 ip, tunnel_2, ip, VDOM Link Interface(TEST0)
```
FG60E (VDOM-US) # get router info routing-table all
B       169.254.30.2/32 [150/100] via 169.254.40.1, aws-us-site, 00:41:24
                        [150/100] via 169.254.41.1, aws-us-site2, 00:41:24
B       169.254.31.2/32 [150/100] via 169.254.40.1, aws-us-site, 00:41:24
                        [150/100] via 169.254.41.1, aws-us-site2, 00:41:24
C       169.254.40.1/32 is directly connected, aws-us-site
C       169.254.40.2/32 is directly connected, aws-us-site
C       169.254.41.1/32 is directly connected, aws-us-site2
C       169.254.41.2/32 is directly connected, aws-us-site2
B       192.168.30.0/30 [150/100] via 169.254.40.1, aws-us-site, 00:41:24
                        [150/100] via 169.254.41.1, aws-us-site2, 00:41:24
C       192.168.40.0/30 is directly connected, TEST20

FG60E (VDOM-US) # execute ping 192.168.30.1
PING 192.168.30.1 (192.168.30.1): 56 data bytes
64 bytes from 192.168.30.1: icmp_seq=0 ttl=250 time=373.3 ms
64 bytes from 192.168.30.1: icmp_seq=1 ttl=250 time=371.4 ms
64 bytes from 192.168.30.1: icmp_seq=2 ttl=250 time=371.4 ms
64 bytes from 192.168.30.1: icmp_seq=3 ttl=250 time=371.9 ms
64 bytes from 192.168.30.1: icmp_seq=4 ttl=250 time=371.5 ms

--- 192.168.30.1 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 371.4/371.9/373.3 ms
```
### AWS 미국리전 Transit Gateway 라우팅 정보
![Routes](./img/aws-us-tgw-routes.png "AWS-US TGW Routing")

### VDOM-USsite (2번째 VDOM)
- TEST1 인터페이스 IP로 한국 FortiGate 장비의 VDOM-KOsite VDOM과 IPsec VPN 연결
- IPsec VPN 연결 후 static routing 설정
- Route to 한국: Loopback40 (내부 네트워크)
- Route from 한국: Loopback30 (내부 네트워크)
```
FG60E (VDOM-USsite) # get router info routing-table all
C       169.254.34.1/32 is directly connected, ko-site-vpn
C       169.254.34.2/32 is directly connected, ko-site-vpn
S       192.168.30.2/32 [10/0] via 192.168.40.1, TEST21
S       192.168.31.0/24 [10/0] via 169.254.34.2, ko-site-vpn
C       192.168.40.0/30 is directly connected, TEST21
C       192.168.41.0/24 is directly connected, loopback40

FG60E (VDOM-USsite) # execute ping 192.168.31.1
PING 192.168.31.1 (192.168.31.1): 56 data bytes
64 bytes from 192.168.31.1: icmp_seq=0 ttl=255 time=381.9 ms
64 bytes from 192.168.31.1: icmp_seq=1 ttl=255 time=379.6 ms
64 bytes from 192.168.31.1: icmp_seq=2 ttl=255 time=378.8 ms
64 bytes from 192.168.31.1: icmp_seq=3 ttl=255 time=380.3 ms
64 bytes from 192.168.31.1: icmp_seq=4 ttl=255 time=379.9 ms

--- 192.168.31.1 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 378.8/380.1/381.9 ms
```