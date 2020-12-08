
function get_num_trees(input_file, num_right_steps, num_down_steps, tree_symbol)
    num_trees = open(input_file) do file
        line_width = -1
        current_position = 1 # we start on the top left 
        num_trees = 0
        lines_to_skip = 0

        for line in eachline(file)
            if lines_to_skip > 0
                lines_to_skip -= 1
                continue
            end

            cleaned_line = collect(strip(line))
            if line_width == -1
                line_width = length(cleaned_line)
            end
            equality = string(cleaned_line[current_position]) == tree_symbol
            
            if equality
                num_trees += 1
            end

            current_position = current_position + num_right_steps

            # we have periodic boundary positions
            if current_position > line_width
                current_position = current_position % line_width
            end

            # this is just a way of coding skipping lines
            lines_to_skip += (num_down_steps - 1)
        end
        num_trees
    end
    num_trees
end

input_steps = [
    (input_file = "day3_input.txt", num_right_steps = 1, num_down_steps = 1, tree_symbol = "#"),
    (input_file = "day3_input.txt", num_right_steps = 3, num_down_steps = 1, tree_symbol = "#"),
    (input_file = "day3_input.txt", num_right_steps = 5, num_down_steps = 1, tree_symbol = "#"),
    (input_file = "day3_input.txt", num_right_steps = 7, num_down_steps = 1, tree_symbol = "#"),
    (input_file = "day3_input.txt", num_right_steps = 1, num_down_steps = 2, tree_symbol = "#")]

all_trees = []
for input_settings in input_steps
    num_trees = get_num_trees(input_settings...)
    println("$input_settings num_trees: $num_trees")
    append!(all_trees, num_trees)
end

prod(all_trees)