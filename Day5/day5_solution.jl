function parse_encoded_string(input_string, lower_bound=0, upper_bound=127, upper_string="F", lower_string="B")

    for direction in input_string
        letter = string(direction)
        if letter == upper_string
            upper_bound = upper_bound - Int32(div(upper_bound - lower_bound, 2, RoundUp))
        elseif letter == lower_string
            lower_bound = lower_bound + Int32(div(upper_bound - lower_bound, 2, RoundUp))
        else
            throw("Invalid string type $letter")
        end
        # println("letter: $letter")
        # println((lower_bound, upper_bound))
    end
    @assert lower_bound == upper_bound
    lower_bound
end

function parse_rows(input_string)
    return parse_encoded_string(input_string, 0, 127, "F", "B")
end

function parse_columns(input_string)
    return parse_encoded_string(input_string, 0, 7, "L", "R")
end

function get_seat_id(input_string)
    row_string = input_string[1:7]
    col_string = input_string[8:end]

    row_num = parse_rows(row_string)
    col_num = parse_columns(col_string)

    seat_id = row_num * 8 + col_num
    seat_id
end

# turns out we didn't need this
function id_to_row_column(seat_id)
    column = seat_id % 8
    row = (seat_id - column) / 8
    row, column
end


function main()
    input_file = "day5_input.txt"

    highest_boarding_pass = open(input_file) do file
        file_string = read(file, String)
        all_seats = split(file_string, "\n")
        all_seats_ids = Vector{Int32}()

        for seat_entry in all_seats
            seat_id = get_seat_id(strip(seat_entry))
            push!(all_seats_ids, seat_id)
        end
        
        set_of_all_seats = Set(all_seats_ids) # easier to test if things are in a set
        for i in minimum(all_seats_ids):maximum(all_seats_ids)
            if !in(i, set_of_all_seats) && in(i-1, set_of_all_seats) && in(i+1, set_of_all_seats)
                println("My seat ID is $i")
            end
        end

        # Debugging
        # sort!(all_seats_ids)
        # println("all_seats_ids: $all_seats_ids")
        maximum(all_seats_ids)
    end
    println("Highest Seat ID: $highest_boarding_pass")
end

#if abspath(PROGRAM_FILE) == @__FILE__
    main()
#end