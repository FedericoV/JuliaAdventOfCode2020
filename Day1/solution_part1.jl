import CSV

# Is this the idiomatic way of specifying types?
# https://csv.juliadata.org/stable/#Providing-Types
file = CSV.File("input_file.txt", header=false; types=[Int])

# Specifying types makes this crash somehow.  Ask Lorenzo later.
complement_dict = Dict()

total = 2020

for row in file
    complement_dict[row[1]] = total - row[1]
end

complement = 0
key = 0

for (k, v) in complement_dict
    try
        complement_dict[v]
        global key = k
        global complement = v
    catch error
    end
end

if complement == 0
    println("Error!!!")
else
    product = key * complement
    println("The two values are $key and $complement.  The product is $product")
end