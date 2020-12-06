import CSV

# Is this the idiomatic way of specifying types?
# https://csv.juliadata.org/stable/#Providing-Types
file = CSV.File("input_file.txt", header=false; types=[Int])

# Specifying types makes this crash somehow.  Ask Lorenzo later.
complement_dict = Dict()
original_values = Set()

total = 2020

for row1 in file
    for row2 in file
        val1 = row1[1]
        val2 = row2[1]

        two_sum = val1 + val2
        if two_sum < 2020
        # all values are positive so
            complement = total - two_sum
            complement_dict[Set([val1, val2])] = complement
            # println("Two sum $val1 $val2 and $complement")
        end
    
    push!(original_values, val1)
    end
end

key1 = 0
key2 = 0
key3 = 0

for (k, v) in complement_dict
    if v in original_values
        tmp_set = collect(k)
        global key1 = tmp_set[1]
        global key2 = tmp_set[2]
        global key3 = v
    end
end

if key1 == 0 && key2 == 0 && key3 == 0
    println("Error!!!")
else
    product = key1 * key2 * key3
    println("The two values are $key1 and $key2 and $key3.  The product is $product")
end