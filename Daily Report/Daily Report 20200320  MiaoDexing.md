# minukube start
- minukube 实际上是kubeadm 安装的，同时minikube 在启动的时候我们可以配置比较多的参数，比如执行镜像源，配置docker 加速
配置主机内存的大小


## minikube start --help


```


Starts a local kubernetes cluster

Options:

      --apiserver-ips=[]: A set of apiserver IP Addresses which are used in the generated

certificate for kubernetes. This can be used if you want to make the apiserver available from

outside the machine

      --apiserver-name='minikubeCA': The apiserver name which is used in the generated certificate

for kubernetes. This can be used if you want to make the apiserver available from outside the

machine

      --apiserver-names=[]: A set of apiserver names which are used in the generated certificate for

kubernetes. This can be used if you want to make the apiserver available from outside the machine

      --apiserver-port=8443: The apiserver listening port

      --cache-images=true: If true, cache docker images for the current bootstrapper and load them

into the machine. Always false with --vm-driver=none.

      --container-runtime='docker': The container runtime to be used (docker, crio, containerd)

      --cpus=2: Number of CPUs allocated to the minikube VM

      --cri-socket='': The cri socket path to be used

      --disable-driver-mounts=false: Disables the filesystem mounts provided by the hypervisors

      --disk-size='20000mb': Disk size allocated to the minikube VM (format: <number>[<unit>], where

unit = b, k, m or g)

      --dns-domain='cluster.local': The cluster dns domain name used in the kubernetes cluster

      --dns-proxy=false: Enable proxy for NAT DNS requests (virtualbox)

      --docker-env=[]: Environment variables to pass to the Docker daemon. (format: key=value)

      --docker-opt=[]: Specify arbitrary flags to pass to the Docker daemon. (format: key=value)

      --download-only=false: If true, only download and cache files for later use - don't install or

start anything.

      --enable-default-cni=false: Enable the default CNI plugin (/etc/cni/net.d/k8s.conf). Used in

conjunction with "--network-plugin=cni"

      --extra-config=: A set of key=value pairs that describe configuration that may be passed to

different components.

  The key should be '.' separated, and the first part before the dot is the component to apply the

configuration to.

  Valid components are: kubelet, kubeadm, apiserver, controller-manager, etcd, proxy, scheduler

  Valid kubeadm parameters: ignore-preflight-errors, dry-run, kubeconfig, kubeconfig-dir, node-name,

cri-socket, experimental-upload-certs, certificate-key, rootfs, pod-network-cidr

      --feature-gates='': A set of key=value pairs that describe feature gates for

alpha/experimental features.

      --host-dns-resolver=true: Enable host resolver for NAT DNS requests (virtualbox)

      --host-only-cidr='192.168.99.1/24': The CIDR to be used for the minikube VM (only supported

with Virtualbox driver)

      --hyperkit-vpnkit-sock='': Location of the VPNKit socket used for networking. If empty,

disables Hyperkit VPNKitSock, if 'auto' uses Docker for Mac VPNKit connection, otherwise uses the

specified VSock.

      --hyperkit-vsock-ports=[]: List of guest VSock ports that should be exposed as sockets on the

host (Only supported on with hyperkit now).

      --hyperv-virtual-switch='': The hyperv virtual switch name. Defaults to first found. (only

supported with HyperV driver)

      --image-mirror-country='': Country code of the image mirror to be used. Leave empty to use the

global one. For Chinese mainland users, set it to cn

      --image-repository='': Alternative image repository to pull docker images from. This can be

used when you have limited access to gcr.io. Set it to "auto" to let minikube decide one for you.

For Chinese mainland users, you may use local gcr.io mirrors such as

registry.cn-hangzhou.aliyuncs.com/google_containers

      --insecure-registry=[]: Insecure Docker registries to pass to the Docker daemon. The default

service CIDR range will automatically be added.

      --iso-url='https://storage.googleapis.com/minikube/iso/minikube-v1.3.0.iso': Location of the

minikube iso

      --keep-context=false: This will keep the existing kubectl context and will create a minikube

context.

      --kubernetes-version='v1.15.2': The kubernetes version that the minikube VM will use (ex:

v1.2.3)

      --kvm-gpu=false: Enable experimental NVIDIA GPU support in minikube

      --kvm-hidden=false: Hide the hypervisor signature from the guest in minikube

      --kvm-network='default': The KVM network name. (only supported with KVM driver)

      --kvm-qemu-uri='qemu:///system': The KVM QEMU connection URI. (works only with kvm2 driver on

linux)

      --memory='2000mb': Amount of RAM allocated to the minikube VM (format: <number>[<unit>], where

unit = b, k, m or g)

      --mount=false: This will start the mount daemon and automatically mount files into minikube

      --mount-string='/Users:/minikube-host': The argument to pass the minikube mount command on

start

      --network-plugin='': The name of the network plugin

      --nfs-share=[]: Local folders to share with Guest via NFS mounts (Only supported on with

hyperkit now)

      --nfs-shares-root='/nfsshares': Where to root the NFS Shares (defaults to /nfsshares, only

supported with hyperkit now)

      --no-vtx-check=false: Disable checking for the availability of hardware virtualization before

the vm is started (virtualbox)

      --registry-mirror=[]: Registry mirrors to pass to the Docker daemon

      --service-cluster-ip-range='10.96.0.0/12': The CIDR to be used for service cluster IPs.

      --uuid='': Provide VM UUID to restore MAC address (only supported with Hyperkit driver).

      --vm-driver='virtualbox': VM driver is one of: [virtualbox parallels vmwarefusion hyperkit

vmware]

      --wait=true: Wait until Kubernetes core services are healthy before exiting

​

Usage:

  minikube start [flags] [options]



```
