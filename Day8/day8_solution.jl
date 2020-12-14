@enum RuleType nop acc jmp

struct Rule
    instruction::RuleType
    qty::Integer
end

Rule(instruction::RuleType) = Rule(instruction::RuleType, 0)

mutable struct Program
    instructions::Vector{Rule}
    state::Integer
    position::Integer
    iteration_counter::Integer
end


function step_program!(program)
    # we execute the rule we are at now
    current_rule = program.instructions[program.position]

    # here are all the rules - maybe should refactor them and dispatch
    if current_rule.instruction == nop
        program.position += 1
        program.iteration_counter += 1

    elseif current_rule.instruction == acc
        program.state += current_rule.qty
        program.position += 1
        program.iteration_counter += 1

    elseif current_rule.instruction == jmp
        program.position += current_rule.qty
        program.iteration_counter += 1
    
    else
        throw("Invalid rule $current_rule")
    end
end


function edit_program_until_it_terminates(program::Program)
    for i in 1:length(program.instructions)
        current_rule = program.instructions[i]
        if current_rule.instruction == acc
            continue
        end

        new_program = deepcopy(program)
        if current_rule.instruction == jmp
            new_rule = Rule(nop, current_rule.qty)
            new_program.instructions[i] = new_rule
        elseif current_rule.instruction == nop
            new_rule = Rule(jmp, current_rule.qty)
            new_program.instructions[i] = new_rule
        end

        if run_program_until_duplicate_line(new_program)
            println("Mutation at line $i gets the program to terminate with $(new_program.state)")
        end
    end
end
          
function run_program_until_duplicate_line(program::Program)
    executed_lines = Set([])
    while !(program.position in executed_lines)
        push!(executed_lines, program.position)
        step_program!(program)
        if program.position == (length(program.instructions) + 1)
            # println("success")
            return true
        end
    end

    # println("Entered loop.  program state: $(program.state) program_iteration $(program.iteration_counter)")
    return false
end



function parse_instruction_into_rule(line)
    # lines look like: nop +0 
    instruction_name, qty = split(line, " ")

    qty = parse(Int64, qty)
    if instruction_name == "nop"
        instruction_type = nop
    elseif instruction_name == "acc"
        instruction_type = acc
    elseif instruction_name == "jmp"
        instruction_type = jmp
    else
        throw("Invalid instruction $instruction_name")
    end
    Rule(instruction_type, qty)
end

function build_program(input_file)
    program = open(input_file) do file
        file_string = read(file, String)
        instructions = split(file_string, "\r\n")
        rules = [parse_instruction_into_rule(line) for line in instructions]
        program = Program(rules, 0, 1, 1)
    end
    program
end

p = build_program("day8_input.txt")
edit_program_until_it_terminates(p)    
    
    

