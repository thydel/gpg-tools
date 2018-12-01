local nodes = import 'nodes.jsonnet';

// { a: [ 1, 2 ], b: [ 3, 4] } => { a: [ { a: 1 }, { a: 2 } ], b: [ { b: 3 }, { b: 4 } ] }
local dist(o) =
std.mapWithKey(
    function(k, l)
    std.foldl(
	function(l, e)
	l + [{ k: k, v: e }],
	l,
	[]),
    o);

// { a: [ 1, 2], b: [ 3, 4]} => [ 1, 2, 3, 4 ]
local merge(o) = std.foldl(function(l, k) l + o[k], std.objectFields(o), []);

local hosts = merge(dist(nodes));
local pass_prefix = 'epiconcept/node/';

local host(name, net) = {
  [name]: {
    ansible_host: name + '.' + net,
    ansible_become_pass: "{{ lookup('passwordstore', '" + pass_prefix + "' + lookup('env','USER') + '@" + self.ansible_host + "') }}"
  },
};

local inventory = {
  all: {
    hosts: std.foldl(function(hosts, h) std.mergePatch(hosts, host(h.v, h.k)), hosts, {}),
    }
};

{
  'nodes.yml': std.manifestYamlDoc(inventory),
}
