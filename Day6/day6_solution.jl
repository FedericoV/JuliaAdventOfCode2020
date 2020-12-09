function get_unique_yes_questions_in_group(group)
    unique_questions = Set{Char}([])
    for line in split(group, "\n")
        new_questions = Set{Char}(collect(strip(line)))
        union!(unique_questions, new_questions)
    end
    unique_questions
end

function get_shared_yes_questions_in_group(group)
    shared_questions = nothing
    for line in split(group, "\n")
        if shared_questions === nothing
            shared_questions = Set{Char}(collect(strip(line)))
        else
            new_questions = Set{Char}(collect(strip(line)))
            intersect!(shared_questions, new_questions)
        end
    end
    shared_questions
end


function main()
    input_file = "day6_input.txt"
    total_unique_questions = open("day6_input.txt") do file
        file_string = read(file, String)
        groups = split(file_string, "\r\n\r\n")
        total = 0
        for group in groups
            new_questions = get_shared_yes_questions_in_group(group)
            total += length(new_questions)
        end
        total
    end
end

main()