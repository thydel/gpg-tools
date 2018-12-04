local sets = {
  oxa: import 'nodes-oxa.jsonnet',
  lxc: import 'nodes-lxc.jsonnet',
};

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

// { a: [ 1, 2 ], b: [ 3, 4 ] } => [ 1, 2, 3, 4 ]
local merge(o) = std.foldl(function(l, k) l + o[k], std.objectFields(o), []);

local hosts = std.mapWithKey(
    function(k, v)
    v + { file: k + '.yml', hosts: merge(dist(v['nodes'])) },
    sets);

local host(name, net, prefix) = {
  [name]: {
    ansible_host: name + '.' + net,
    ansible_become_pass: "{{ lookup('passwordstore', '" + prefix + '/' + "' + lookup('env','USER') + '@" + self.ansible_host + "') }}"
  },
};

local inventories = {
  [set]: {
    all: {
      hosts: std.foldl(function(a, h) std.mergePatch(a, host(h.v, h.k, hosts[set].pass_prefix)), hosts[set].hosts, {})
    }
  }
  for set in std.objectFields(hosts)
};

{ [set + '_out.yml']: std.manifestYamlDoc(inventories[set]) for set in std.objectFields(inventories) }

# Local Variables:
# indent-tabs-mdode: nil
