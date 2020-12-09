include("day5_solution.jl")
using Test

@test parse_rows("FBFBBFF") == 44
@test parse_columns("RLR") == 5

@test get_seat_id("BFFFBBFRRR") == 567
@test get_seat_id("FFFBBBFRRR") == 119
@test get_seat_id("BBFFBBFRLL") == 820

@test id_to_row_column(357) == (44, 5)