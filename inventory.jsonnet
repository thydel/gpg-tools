local nodes = import 'nodes.jsonnet';
local pass_prefix = 'epiconcept/node/';

local host(name, net = 'admin2') = {
  [name]: {
    ansible_host: name + '.' + net,
    ansible_become_pass: "{{ lookup('passwordstore', '" + pass_prefix + "' + lookup('env','USER') + '@" + self.ansible_host + "') }}"
  },
};

local hosts = [ 'prot1bddb1', 'prot1bdda1' ];

local inventory = {
  all: {
    hosts: std.foldl(function(hosts, h) std.mergePatch(hosts, host(h)), hosts, {}),
    }
};

{
  'nodes.yml': std.manifestYamlDoc(inventory),
}
