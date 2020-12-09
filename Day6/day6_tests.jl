include("day6_solution.jl")

entry = "abcx
abcy
abcz"
@test get_unique_yes_questions_in_group(entry) == Set(['a','b','c','x','y','z'])

shared_entry = "ymw
w
wm
vsw
wm"
@test get_shared_yes_questions_in_group(shared_entry) == Set(['w'])