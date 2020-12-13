include("day7_solution.jl")
using Test

test_string_1 = "light red bags contain 1 bright white bag, 2 muted yellow bags."
expected_output_1 = [("light red", "bright white", 1), ("light red", "muted yellow", 2)]
@test edges_from_rule(test_string_1) == expected_output_1

test_string_2 = "faded blue bags contain no other bags."
expected_output_2 = [("faded blue", nothing, 0)]
@test edges_from_rule(test_string_2) == expected_output_2