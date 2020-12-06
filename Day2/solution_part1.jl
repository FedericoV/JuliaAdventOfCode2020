input_file = "input_file.txt"

function parse_line(line)
    # lines look like this: 8-12 f: fmffhjmfkxfrvcfrbr
    line_chunks = split(line, ":")

    password = strip(line_chunks[2])

    # this part: 8-12 f
    left_chunk = strip(line_chunks[1])

    tmp1 = split(left_chunk, "-")
    min_count = parse(Int32, tmp1[1])
    
    tmp2 = split(tmp1[2], " ")
    max_count = parse(Int32, tmp2[1])
    letter = only(tmp2[2]) # converts this from substring to character
    
    min_count, max_count, letter, password
end

function validate_password1(min_count, max_count, letter, password)
    string_array = collect(password)

    letter_count = 0
    for c in string_array
        equality = c == letter
        # println("$c $(typeof(c)) $letter $(typeof(letter)) $equality")
        if equality
            letter_count += 1
        end
    end
    # println(letter_count)
    valid_password = letter_count >= min_count && letter_count <= max_count
end


function validate_password2(pos1, pos2, letter, password)
    string_array = collect(password)
    valid_password = xor(string_array[pos1] == letter, string_array[pos2] == letter)
end
        

# This should possibly be an enum but they seem clunky and un-idiomatic in Julia?
password_mode = 2
open(input_file) do file
    valid_passwords = 0
    for line in eachline(file)
        min_count, max_count, letter, password = parse_line(line)
        if password_mode == 1
            if validate_password1(min_count, max_count, letter, password)
                valid_passwords += 1
            end
        elseif password_mode == 2
            if validate_password1(min_count, max_count, letter, password)
                valid_passwords += 1
            end
        end
    end
    valid_passwords
end