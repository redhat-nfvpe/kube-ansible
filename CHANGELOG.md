# Release v0.2.0
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/25feeffc78ff312892709e0e70643e5a196c70b8) -- Use Docker CE repo for builder VM
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/2d59aa57b7bbe534652e840d83a2a75315c62066) -- Update project name to kube-ansible

# Release v0.1.8
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/662b0fff8d75200f95ffd3af4097f6c2efa28dbc) -- [typos][minor] Replaces kubadm with kubeadm
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/077b4eb2ff43e367e122a646ed894308f70d3525) -- [feature][optional-packages] Adds role that can handle installing optional packages should deployers wish to extend the packages available on master & nodes
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/7f703b41c67e39084c2b405af47dc43687b031cb) -- [hotfix][multus-crd] Typo in template name, more appropriate CNI config name: param
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/4400aa8990c10dcdd610c16400bf6b98711d81ab) -- [bugfix][multus-cni] Missing customized clusterrole for node api calls
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/bf4991b7755dd6e06c7b1c1789110c8b5d41f036) -- Copies artifacts from the builder to the k8s nodes
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/1267af8c833a18d78045837d7f258529f616c092) -- Adds group_vars/builder.yml
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/3d00560945a4afb8d74a738bf6cb4214d9ee76c0) -- Cleans up Ansible linting for virthost-setup
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/303cfbf7f83ce57e1c1305738e88985beee0f60d) -- [hotfix] Revert erroneous lint fix in attach disks
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/f78e4eebb0cedbb630905edd7d3eb121343ab056) -- [feature][minor] adds variable to skip virthost depedencies
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/460b9720420dcb079b4be6efed35230ffd05ed2b) -- Avoids duplicating builder plays

# Release v0.1.7
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/ba786202b0fcf7916fb2fb131e713a3a18f5e80f) -- Allow customization of VM vCPU and vRAM values
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/a742a2221df5cf614fe963da45caa812f3afbd9d) -- [WIP] Update to using install-go external role
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/704e91e42307d9759f43b1c6fb7e3a2f06cba37c) -- Drop when clause in var include for kube-install
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/809bf2b738fb5ce6e662bcea8865c9d7ce12c540) -- Migrate to using install-docker role
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/5e579caba56761a17cd33a29386161439c33be3a) -- Fix proxy ssh failure in vms.local.generated
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/f0443b46c343b0d52b06871934af3eab836f114a) -- Adds ability to build k8s
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/9317b6ef1f46f587403c434d688ac8659d182986) -- Moves additional scenarios and usage
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/9b04578b38ad99488f1c67b18f45651df1f45c2a) -- Fix link to IPv6 documentation
* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/35090f565a96892593c4cae90b428f0fe62c2422) -- Changes related to release v0.1.7

# Release 0.1.6
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/44136f7f4af41d4af94e3872726f206635e3f821) -- Convert kube-centos-ansible to kucean
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/920fc8381410a2ea96601c2947c72c60303b2310) -- Avoid use of ansible_host and machine UUID
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/03408112e2d93b1ff109f25196f19243e0ba2cf2) -- [feature] adds 'binary install' option to override kubelet, kubectl and kubeadm with custom binaries. addresses #81
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/199d37964987151666aeffe15fc38167e33d36cc) -- Drop the use of all_vms
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/2071e69431d56d90d5ffa457cd0ddcaaeb384235) -- Add new role to gather kube niceties
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/1a0e5305c5d7722f1cf7477538669357b49bf615) -- Load virthost privkey onto source machine
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/186696d759cbbcdd99c8b250276c49e6a491d4a6) -- Drop old GlusterFS playbooks
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/8464f881d7398286c8877cff9bbd111e6b0bbe74) -- Enhance documentation and usage experience
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/aea24e7a22e600d3a156c67f28f12621788a1888) -- [HotFix] Complete missing documentation for kubectl
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/d8ff428e0074629387160f6f4a12194fcb793b7b) -- Add LICENSE file to the project
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/0822a412af3905c337db4d498b5a59a7816b3031) -- [multus][upgrade] Adds latest Multus including CRD functionality. Address #78 and #72
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/509ca38a99370137b0ae4c6f369b4952d648c4cc) -- Add AUTHORS and CHANGELOG
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/38dca9194515bb1a61a017b21f9b6ef11f351da4) -- Add base IPv6 lab functionality (#106)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/b1db349673aa565227a1662e7b56e3726016aaef) -- [ipv6][docs][bugfix] Has some required (minor) fixes to get the IPv6 deploy running and includes some docs to help one initially get there

# Release 0.1.5
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/a916eb5697e5d6fbc7d510c7184f27e5f0511648) -- [bugfix][workaround] workaround to get proper kubectl version
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/2711d41882db0c2ae10a329c86d21a7a5f73d69c) -- Lock version of kubernetes
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/9fee8152ed499d541f1790caff30f03d620f3a22) -- Fix port for ssh proxy
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/179c18f84388dfc24a0feb5e7ab64360da0a4f66) -- Add ssh_proxy_port and tag k8s to a known working version
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/259cf6426b36e94637d2034561ab1dfd95baaf07) -- [kube1.8] updates to have a working glusterfs in kubernetes 1.8 per #63
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/fd626f2c71d484fcd6cf05c5e7b69cc7ab8c1f75) -- [kube1.8] updates to use systemd module for kubectl-proxy service, removes blank file
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/9c5a6574c00283ee3de233bd4a8ae236d996b277) -- [minor] updates to latest stable Heketi
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/41e4e09606454cd3ce705dbf7d09ac3d25b30155) -- Clean up some missing values

# Release 0.1.4
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/96be541ae41062c1be30391bb99315219c2a7a33) -- [docs] sweeping find & replace of 'minion' with 'node'
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/c40c9ea706353b678a35ab4e32005a4d687bd0b2) -- [bugfix][glusterfs] oops missed removing environment after refactoring admin.conf for kube
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/c6e58b212caa7b0b7de51b743d9c785f97273934) -- [gluster][workaround] Works around upstream gluster-kubernetes with pinning heketi image tag

# Release 0.1.3
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/7ce47b6ae3738eb6b3992bc7be7c0b1dc4e3c7d1) -- [crio][bugfix] Turns out with Fedora, you sometimes need to expand the root disk, on the VM side

# Release 0.1.2
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/12b6c616b0b10dd17ef933c8eb738e3ef0640738) -- Further cleanup of the inventory
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/27e8fad9748ebaecd23f6538f3da4efc666d90da) -- [hotfix][version-pin] update for pinning gluster-kubernetes
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/415a48e27cf5240d5bb03769f899dcb0fedaccda) -- Remove VM disk image on teardown
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/976b376cbd80ed4290380023eac4ea59fbce982b) -- [hotfix][minor] update spare disk creation to use qemu-img to speed it up
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/d86f8357fa465654a06601220f095e0dca341d93) -- [hotfix] Revert minion 3 delete
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/5ab66a4dae960c8723cca5f33a307f300dab4c4c) -- [bugfix][glusterfs] Pins version to last known good commit, by Doug's analysis
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/6c31e6d2525876031d99fbb32e71f99148da4a51) -- [hotfix][minor] Drop hard coded TLD hostname
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/20573ffcb84452bdb4b25c391bdf5fb4a15c303e) -- [major] Dynamically generate and control VM inventory
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/2def0f63bce924e27ba34a4d0deaa01881aadfac) -- [hotfix] Revert breaking indent
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/b5d12cbbffa7ce54630123e23a13c69ced21b898) -- [gluster] defaults to running attach disk in virt-host-setup
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/338f1d28f7dfa7d113babf76057059e949b3afe8) -- [hotfix] Don't become root when it breaks installation
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/5558ba75c1840a143fbc0c02d331cb3b420be22e) -- [minor] Clean up some documentation errors
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/a54e65619fd883790624d9f07b1d5a482de21bea) -- [crio] updates to later cri-o tag for kube 1.7
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/f0ed4a8d30b3505f0e327d3882a4359d18abb50b) -- [minor][refactor] remove dictionary for vm parameters (makes it easier on adding extra vars)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/120d7e3f2798efccdb25c27f17f0f29c1a549c1f) -- [crio] adds example for crio with buildah
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/cc1369b9cf9d1420205378cf14a78686ef4383f4) -- [crio][refactor] Addresses #52 for refactor to support Fedora (specifically to address Buildah requirements)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/00092dd59a0fc9a291287665f9e2739ecf838e07) -- [crio][docs] update docs for readme clarity / voice, and clean up inventory

# Release 0.1.1
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/b10f9912a4101fec790216e65c8f5a8ced7d6e18) -- [minor][inventory] current inventory style
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/a4380c09246ff6982b24aff1e7614c5440df1de0) -- [minor] adds a handy-dandy get-ip script for getting IPs of VMs
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/d3ab8b01ad0c4ef999bc627f04034c6e3d6333b2) -- [crio] updates for crio, trying to get to work with 1.7 but didn't work

# Release 0.1.0
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/ae9f7f4f51fb52377589ec439520a6134243d5bd) -- [glusterdynamic][stub] stubbing in json template for glusterfs topology
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/3ed501088e81da551ad68fe8eaa96f1935abd40f) -- [glusterdynamic][increment] has basic steps, but, erroring out at gluster-kubernetes 290
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/07521d9cc6fb62ba132ff4bff567a664d952c2a7) -- [hotfix] Adds kubernetes version specification capability
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/a716993ea75ab8d31511e12754381063118df247) -- [glusterdynamic][significant] allows for manual running of gk-deploy which finishes successfully (unverified)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/3c01fef4ea322863ce906a37ff1cbf2991f34b85) -- [glusterdynamic] steps for running the gk-deploy and creating storage class

# Release 0.0.6
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/3cc2ea6b25edb2e68917f16c49d5f708597d3f05) -- [ansible23][minor] ignore errors in undefine all vms play
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/2828f3ed92700435173e652e456d3b888f3f852b) -- [ansible23] fixes for virt host setup
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/ab155a269018dfafa08041c2b76b0b8c115fd21f) -- [ansible23] syntax fixes for deprecation of jinja2 in conditionals
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/bd1f113d8fe74f6bfca9aa3ffd24dce7d3bded6a) -- [bugfix][minor] missing refactor for group vars in gluster-recreate-volumes playbook

# Release 0.0.5
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/463605c0254ff79369c4b81826cabbccc42d802d) -- Clean up some Ansible lint issues
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/b827da2c3a6ca43e44639e36737361641b3ae0dd) -- Break out firewall service name
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/0852798e81caf69add9495bb723c8716fca13862) -- [bridge-networking] adds option to use bridged networking instead of NAT'd
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/db901b322c15198641715ada1b83ae30982f5c99) -- [vars] change default to bridged networking
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/9c27633212a85010aeefb995f64cf209fafe07fa) -- [minor] proper conditional for get ips for bridge networking
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/b6fd6e681c5c7c02c8062cca42ca126c83d45647) -- [bugfix] sets /proc/sys/net/bridge/bridge-nf-call-iptables in tasks
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/54fad01761991b02f95495a03fac57d636974239) -- [docs] updates readme to remove 1.5 reference
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/9e651231888791dba62512ba976a67b0b2831377) -- [minor] skip network restart when bridge network is not freshly templated
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/125b3179bda867443f0825dd1a509ad1dd9eaa29) -- [vars] adds option to skip-preflight-checks when necessary (in this case to bypass kubeadm join bug in kube 1.7.2 dist)

# Release 0.0.4
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/34f72e065f7342cd8cc0d90cc887f13b4a645108) -- [crio][stub] mostly stubs in from existing crio ansible playbook
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/b6c0792d821474d2a50366b16587075699b90568) -- [cri-o][significant] has a running cri-o, but, no ancillary tools
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/cf3e1373fc9055c46e8e2fcfeed25115a052e2fe) -- [buildah] has a successful buildah install (it doesn't do much for now)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/d8da31e344147ce06c8b7a7dbb951b2974bfb6f5) -- [cri-o][bugfix] fixes cri-o build error (the one requiring a second run), disables buildah for now
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/e13802cbea4ddaa4ef128983ac4c9a5236dad639) -- [cri-o] cleanup inventory and vars
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/bff2a4e2744b407358bf1c8a3fe8da89e3ae3861) -- [cri-o][docs] updates readme for extra var
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/c31b0edfb2e22b7b6174e5aba2e7e4c60e32cf74) -- Allow for easier variable overrides

# Release 0.0.3
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/29a2117fb4cb8f819266b243c2e111f416692b12) -- [glusterfs] has playbook for attaching spare disk to VMs
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/a0cb7dab8ec46cd410eafe02e6fa057d18d36d39) -- [glusterfs] has creation of 'bricks' the xfs physical volumes & volume groups
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/f8593687f17c8e64305c30d1d1148283795dd157) -- [glusterfs] has peers joining
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/6bdcf20dea40de134084e87ee38866d32aa37e01) -- [glusterfs][significant] has a working glusterfs cluster
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/5dc97de635ddba4fe98d4d9d5a9a37ad70f2e12d) -- [glusterfs] has templates put on disk on master (but not applied)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/30da8d2bf7ebc4dd1e6bf031397d45b5c11ce5a6) -- [glusterfs] breaks out volume creation from peer probe to create multiple glusterfs volumes
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/e4fc92d50aab5f662900e608ea1912ccd105578c) -- [glusterfs][minor] changes reclaim policy to delete from recycle (recycle failed, and delete makes sense for a prototype)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/4d834710b53c2e034f2e1e6dafb65cbdbba8c258) -- [glustefs][minor] adds storage class to try to work around glitch
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/81cdb80965771c2edbb92bdbda42b96d613b1676) -- [glusterfs] add playbook just for recreating volumes (otherwise, difficult to delete and start fresh)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/916a74b872bc6ea4c3d09f2ffb3aa4c2aaac6975) -- [glusterfs] has proper method for actually deleting date when recreating volumes
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/6da71bd3b6f091c13b743e674b11cf19b1992275) -- [glusterfs][oops] didn't have proper volume names in volumes yaml
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/6c287e992a7c37e6a3a7b3fc9bcbf7b46b4fd0c3) -- [glusterfs][oops] I had a debug when in there, needed to flip it back, also had wrong template name
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/d3a0a900cba81f4882748ebc73a7b30d52a48dd2) -- Convert yum to package
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/0b08998cf2449ec15a99aad8051ee7ec49c8ce47) -- Clean up use of mustaches in when conditionals
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/c0de028b17513d68fce9b95950c0ee15d11844f9) -- Ignore everything in inventory (except samples)
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/8962459faa68af1a53b351f1e8ecd91e85d5b385) -- Also need to ignore the inventory/ directory...
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/98dd9a5842850073b1ee77576c9554aee794b170) -- Revert "Clean up use of mustaches in when conditionals"
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/c2b18cb8de1fee5365f674ebcf94c77426274c5e) -- Add ansible.cfg to avoid hostkey checking
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/58ae61d2ae97966eb18923c5a685c2518d0959d3) -- [bugfix] fixes #6 for bridge-nf-call-iptables
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/c94b6ee7a7939fca1783676bc1fb25633704dbbd) -- [fixbridge][bugfix] wrong spot for changing /proc/sys/net/bridge/bridge-nf-call-iptables

# Release 0.0.2
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/138ddf4e4b54731a44d3de9dc6b009065e1184f0) -- [increment][no-cni] has an install generally working, no e2e test complete with it. DNS pod not coming up, flannel not coming up
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/b81f47123ac9a216245b452bac37cd0aa22a9c3a) -- [upgrade16] adds flannel rbac, and has had a successful run getting flannel pods up (and dns pod) but can't curl an nginx pod, pods can't reach wan
* [view commit](http://github.com/redhat-nfvpe/kube-centos-ansible/commit/258fdb38ccd7dbd584ff917bdbff80c362a9ff7f) -- [upgrade16] has a working k8s 1.6.1 beta install, downgraded docker to 1.12.x
