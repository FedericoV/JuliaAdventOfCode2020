using IterTools
using ProgressMeter

function find_first_invalid_number(input_numbers, window_length)

    @showprogress for (j, i) in enumerate(window_length + 1:length(input_numbers))
        input_subset = input_numbers[j:j + window_length - 1]
        valid_sums = Set([sum(subset) for subset in subsets(input_subset, 2)])
        if !(input_numbers[i] in valid_sums)
            return (input_numbers[i], i)
        end
    end
end

# Invalid number is 507622668

function find_consecutives_that_sum_to_total(input_numbers, bad_number, bad_number_idx)
    @showprogress for i in 1:bad_number_idx
        j = i + 1
        running_sum = 0
        sequence = []
        while running_sum < bad_number
            running_sum += input_numbers[j]
            push!(sequence, input_numbers[j])
            j += 1

            if running_sum == bad_number
                println("Sequence: $sequence")
                min_seq = minimum(sequence)
                max_seq = maximum(sequence)
                println("sum of min and max: $(min_seq + max_seq)")
            end
        end
    end
end




function parse_file_to_input(input_file)
    input_numbers = open(input_file) do file
        file_string = read(file, String)
        [parse(Int64, line) for line in split(file_string, "\r\n")]
    end
    input_numbers
end

function main(input_file, window_length)
    input_numbers = parse_file_to_input(input_file)
    bad_numbers_and_idx = find_first_invalid_number(input_numbers, window_length)
    println("$bad_numbers_and_idx")
end

function part2(input_file)
    input_numbers = parse_file_to_input(input_file)
    find_consecutives_that_sum_to_total(input_numbers, 507622668, 634)
end

# main("day9_input.txt", 25)
part2("day9_input.txt")