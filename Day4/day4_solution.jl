function validate_birth_year(field_value)
    birth_year = try
        parse(Int32, field_value)
    catch e
        return false
    end
    
    if (birth_year >= 1920 && birth_year <= 2002)
        return true 
    end
    false
end

function validate_issue_year(field_value)
    issue_year = try
        parse(Int32, field_value)
    catch e
        return false
    end
    if (issue_year >= 2010 && issue_year <= 2020)
        return true
    end
    false
end

function validate_expiration_year(field_value)
    expiration_year = try
        parse(Int32, field_value)
    catch e
        return false
    end

    if (expiration_year >= 2020 && expiration_year <= 2030)
        return true
    end
    false
end

function validate_height(field_value)
    unit_type, unit_value = try
        field_value[end - 1:end], parse(Int32, field_value[1:end - 2])
    catch e
        return false
    end

    if unit_type == "cm"
        if (unit_value >= 150 && unit_value <= 193)
            return true
        end
    elseif unit_type == "in"
        if (unit_value >= 59 && unit_value <= 76)
            return true
        end
    else
        return false
    end
    false
end

function validate_hair_color(field_value)
    hair_color_regex = r"^#[a-f|0-9]{6}"
    if length(field_value) == 7 && (occursin(hair_color_regex, field_value))
        return true
    else
        return false
    end
end

function validate_eye_color(field_value)
    valid_eye_colors = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
    if in(field_value, valid_eye_colors)
        return true
    else
        return false
    end
end

function validate_pid(field_value)
    pid_regexp = r"^[0-9]{9}"
    if length(field_value) == 9 && occursin(pid_regexp, field_value)
        return true
    else
        return false
    end
end


function is_valid_passport(passport, validate_fields=true, debug=false)
    passport_fields = split(passport, r"[(\r\n)\s]")

    # we leave CID out since it's not needed
    required_fields = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

    # we define those here to avoid creating them in a loop - tiny optimization
    # for regexp it might matter since it's compiled

    present_in_pwd_fields = Set([])

    for field_and_value in passport_fields
        if length(field_and_value) == 0
            continue
        end

        field_name = strip(split(field_and_value, ":")[1])
        valid_entry = false

        if validate_fields
            field_value = strip(split(field_and_value, ":")[2])

            # byr (Birth Year) - four digits; at least 1920 and at most 2002
            if field_name == "byr"
                if validate_birth_year(field_value)
                    valid_entry = true
                elseif debug
                    println("byr $field_value")
                end

            # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
            elseif field_name == "iyr"
                if validate_issue_year(field_value)
                    valid_entry = true
                elseif debug
                    println("iyr $field_value")
                end

            # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
            elseif field_name == "eyr"
                if validate_expiration_year(field_value)
                    valid_entry = true
                elseif debug
                    println("eyr $field_value")
                end
            

            # hgt (Height) - a number followed by either cm or in:
            # If cm, the number must be at least 150 and at most 193.
            # If in, the number must be at least 59 and at most 76.            
            elseif field_name == "hgt"
                if validate_height(field_value)
                    valid_entry = true
                elseif debug
                    println("hgt $field_value")
                end
                

            # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f
            elseif field_name == "hcl"
                if validate_hair_color(field_value)
                    valid_entry = true
                elseif debug
                    println("hcl $field_value")
                end
            
            
            # (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
            elseif field_name == "ecl"
                if validate_eye_color(field_value)
                    valid_entry = true
                elseif debug
                    println("ecl $field_value")
                end
            

            elseif field_name == "pid"
                if validate_pid(field_value)
                    valid_entry = true
                elseif debug
                    println("pid $field_value")
                end

            else
                valid_entry = false
            end
        end
        if valid_entry
            push!(present_in_pwd_fields, field_name)
        end
    end

    delete!(present_in_pwd_fields, "cid")

    if present_in_pwd_fields == required_fields
        return true
    else
        return false
    end
end


function main()
    input_file = "day4_input.txt"

    num_valid_passports = open(input_file) do file
        file_string = read(file, String)
        num_valid_passports = 0
        passports = split(file_string, "\r\n\r\n")

        for passport in passports
            if is_valid_passport(passport)
                num_valid_passports += 1
            end
        end
        num_valid_passports
    end
    println("Number of Valid Passports: $num_valid_passports")
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

