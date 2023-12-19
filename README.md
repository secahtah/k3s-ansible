# k3s-ansible

This repository contains Ansible roles to build out a fully functional k3s
kubernetes cluster. While it is assumed that this will be built out on 
Raspberry Pi systems, it will work with other physical or virtual deployments.

# Requirements
The operating system target is initially Oracle Linux, but the other Red Hat
clones should work just fine as well.

# Architecture
You can use whatever k3s design you want with k3s-ansible, but please
be advised that the reference architecture that it currently
implements is as follows:

<image src="./k3s-architecture-ha-external.png">
Source: https://docs.k3s.io/img/k3s-architecture-ha-external-dark.svg


The goal of the architecture is threefold: 
- Low power: I wanted to squeeze out the maximum amount of computing
power per watt as I could, so I went with Raspberry Pis for the compute form factor due to the low power consumption of the ARM architecture
- Cost: It's possible to build out an impressive amount of compute power without breaking the bank, and that is also accomplished via Raspberry Pis
- Highly available: I didn't want a single node taking down the 
entire cluster, so I elected to use a multi-server deployment of ```k3s```

To make the server nodes as cheap as possible, I chose to split a 
couple of the components out (this may come back to haunt me later, and rest assured if it does, I'll rewrite these components):
- Database: The embedded etcd database doesn't perform well on 
Raspberry Pi systems which use SD cards for primary storage - but I wanted to keep the power budget and cost as low as possible. So I built out a ```database``` node on another Pi, running postgresql 
(a roadmap feature is to make that service highly available as well, when cost doesn't prohibit). The postgres instance is implemented 
via a container architecture, running inside of a rootless ```podman``` container. I didn't really want any applications
running outside of containers in this architecture.
- Persistent Storage: One of the requirements of the reference architecture cluster I built out is persistent storage. Ideally, 
I'd have a qnap or synology low-power NAS for this, but I don't. 
So I consumed two SSDs from stock and used these for the storage backing the postgres and NFS services. 

But then I chose one more spin on this design, and that's with respect to the load-balancers.
- External versus Internal load balancer: As you can see in the sample architecture from the k3s website above, there are two load
balancers in this topology. In the design presented here, I did not 
use separate nodes for this, and nor did I stack all of the load
balancing responsibilities onto the storage node. Instead, I decided
to use ```metallb``` as the external load balancer, and ```haproxy```
as the internal load balancer. Metallb is implemented from within
k3s, and runs on any node that exposes a service. Conversely,
haproxy runs from outside k3s because it provides load balancing for the ```kube-apiserver``` component of k3s -- and it runs on the 
k3s-server nodes.

