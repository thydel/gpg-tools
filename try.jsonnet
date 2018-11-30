local nodes = import 'nodes.jsonnet';

local dist(name, list) = std.foldl(function(a, elt) a + [{ net: name, node: elt }], list, []);

std.mapWithKey(dist, nodes)
