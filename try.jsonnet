local nodes = import 'nodes.jsonnet';

local dist(name, list) = std.foldl(function(list, elt) list + [{ net: name, node: elt }], list, []);
local merge(dict_of_list) = std.foldl(function(l, k) l + dict_of_list[k], std.objectFields(dict_of_list), []);

local foo = std.mapWithKey(dist, nodes);

local bar = std.objectFields(foo);

//std.foldl(function(l, k) l + foo[k], bar, [])

merge(std.mapWithKey(dist, nodes))

//foo

//std.mapWithKey(function(k, v) k, foo)

//std.foldl(function(

/*
std.mapWithKey(
    function(k, v)
    std.foldl(
	function(l, e) l + v,
	std.mapWithKey(
	    function(n, l)
	    std.foldl(
		n(l, e) l + [{ net: n, node: e }], l, []), nodes), []), [])

 */
