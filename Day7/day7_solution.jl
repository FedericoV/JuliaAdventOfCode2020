using SimpleWeightedGraphs
include("bijection_map.jl")

function edges_from_rule(rule_string)
    # rules are like this: light red bags contain 1 bright white bag, 2 muted yellow bags.
    parent_bag_string, other_bags_string = split(rule_string, "contain")
    parent_bag = strip(split(parent_bag_string, "bag")[1])
    other_bags_descriptions = split(other_bags_string, ",")

    edges = []
    for children_bag_description in split(other_bags_string, ",")
        child_bag_with_count = strip(split(children_bag_description, "bag")[1])

        # special case: handle no other
        if occursin("no other", child_bag_with_count)
            return [(parent_bag, nothing, 0)]
        end

        child_bag_count = parse(Int32, child_bag_with_count[1])
        child_bag = strip(child_bag_with_count[2:end])

        push!(edges, (parent_bag, child_bag, child_bag_count))
    end
    edges
end

function add_nodes_and_ids!(nodes_to_ids, node)
    if node === nothing
        return
    end

    node = String(node)
    if !haskey(nodes_to_ids, node)
        node_id = length(nodes_to_ids) + 1
        nodes_to_ids[node] = node_id
    end
end

function get_edges_and_nodes(input_file)
    edges, nodes_to_ids = open(input_file) do file
        file_string = read(file, String)
        rules = split(file_string, "\r\n")
        
        # note - Julia doesn't have bidicts... annoying.
        # also annoying - Julia graphs require you to use integers
        # for nodes.

        edges = []
        nodes_to_ids = BiDict{String,Int64}()
        for rule in rules
            rule_edges = edges_from_rule(rule)
            for edge in rule_edges
                node_1, node_2, edge_weight = edge
                add_nodes_and_ids!(nodes_to_ids, node_1)
                add_nodes_and_ids!(nodes_to_ids, node_2)
            end
            # println(edge_rules)
            append!(edges, rule_edges)
            # println("edges: $edges")
        end
        edges, nodes_to_ids
    end
    edges, nodes_to_ids
end


function build_graph(edges, nodes_to_ids)
    num_nodes = length(nodes_to_ids)
    g = SimpleWeightedDiGraph(num_nodes)
    for (n1, n2, num_bags) in edges
        if !(n2 === nothing)
            id1, id2 = nodes_to_ids[String(n1)], nodes_to_ids[String(n2)]
            # println("edge from: ($n1 $id1) to ($n2 $id2)")
            add_edge!(g, id1, id2, num_bags)
        end
    end
    println("number of vertex: $(nv(g))")
    println("number of edges: $(ne(g))")
    g
end

function find_parent_bags(g, nodes_to_ids, target_node)

    target_node_id = nodes_to_ids[String(target_node)]
    println("target_node: $target_node node_id: $target_node_id")
    all_parent_nodes = []
    for (node_name, node_id) in nodes_to_ids.key_to_value
        if (node_id != target_node_id) && (has_path(g, node_id, target_node_id))
            push!(all_parent_nodes, node_name)
        end
    end
    println("all bags: $all_parent_nodes")
    println("num bags: $(length(all_parent_nodes))")
end


function calculate_costs(g::AbstractGraph{T}, s::Integer, node_cost::Float64) where {T}
    nbs = outneighbors(g, s)
    println("Source: $s nbs: $(collect(nbs))")
    for n in nbs
        node_cost += calculate_costs(g, n, 1.0) * g.weights[n, s]
        println("Source: $s Node: $n edge weight: $(g.weights[n, s]) total cost so far: $node_cost")
    end
    node_cost
end

function part1_sol()
    edges_tuple, nodes_to_ids = get_edges_and_nodes("day7_input.txt")
    g = build_graph(edges_tuple, nodes_to_ids)
    find_parent_bags(g, nodes_to_ids, "shiny gold")
    return g
end

function part2_sol()
    edges_tuple, nodes_to_ids = get_edges_and_nodes("day7_input.txt")
    g = build_graph(edges_tuple, nodes_to_ids)

    start_node_id = nodes_to_ids[String("shiny gold")]
    calculate_costs(g, start_node_id, 0.0)
end

part2_sol()

