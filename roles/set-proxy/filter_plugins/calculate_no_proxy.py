# Copyright (c) 2015-2018, Intel Corporation.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Intel Corporation nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
from collections import OrderedDict


def contextfilter(f):
    """Decorator for marking context dependent filters. The current
    :class:`Context` will be passed as first argument.
    """
    f.contextfilter = True
    return f


@contextfilter
def do_calculate_no_proxy(context, proxy_env):
    # if proxy_env is empty, abort
    if not proxy_env:
        return proxy_env
    no_proxy = []
    try:
        node_info = context['node_info']
    except KeyError:
        pass
    else:
        node_set = set(node_info)
        all_hosts = set(context['groups']['all'])
        current_hosts = all_hosts.intersection(node_set)
        no_proxy.extend(node_info[host]['networks']['mgmt']['ip_address'] for host in current_hosts)
    try:
        no_proxy.append(context['kolla_internal_vip_address'])
    except KeyError:
        pass
    try:
        if context['kolla_internal_vip_address'] != context['kolla_external_vip_address']:
            no_proxy.append(context['kolla_external_vip_address'])
    except KeyError:
        pass
    if no_proxy:
        no_proxy_dict = OrderedDict.fromkeys(proxy_env['no_proxy'].split(','))
        no_proxy_dict.update((k, '') for k in no_proxy)
        proxy_env['no_proxy'] = ','.join(no_proxy_dict)
    return proxy_env


class FilterModule(object):
    def filters(self):
        return {
            'calculate_no_proxy': do_calculate_no_proxy,
        }
