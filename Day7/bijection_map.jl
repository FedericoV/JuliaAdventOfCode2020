mutable struct BiDict{K,V}
    key_to_value::Dict{K,V}
    value_to_key::Dict{V,K}
end

function Base.haskey(d::BiDict{K,V}, key::K) where {K,V}
    return haskey(d.key_to_value, key)
end

function Base.haskey(d::BiDict{K,V}, value::V) where {K,V}
    return haskey(d.value_to_key, value)
end


function Base.getindex(d::BiDict{K,V}, key::K) where {K,V}
    d.key_to_value[key]
end

function Base.getindex(d::BiDict{K,V}, value::V) where {K,V}
    d.value_to_key[value]
end

function Base.setindex!(d::BiDict{K,V}, key::K, value::V) where {K,V}
    if haskey(d.value_to_key, value)
        old_key = d.value_to_key[value]
        throw(Base.KeyError("$value is already associated with $old_key"))
    end
    d.key_to_value[key] = value
    d.value_to_key[value] = key
end

function Base.setindex!(d::BiDict{K,V}, value::V, key::K) where {K,V}
    if haskey(d.key_to_value, key)
        old_value = d.key_to_value[value]
        throw(Base.KeyError("$key is already associated with $old_value"))
    end
    d.key_to_value[key] = value
    d.value_to_key[value] = key
end

function Base.delete!(d::BiDict{K,V}, key::K) where {K,V}
    value = d.key_to_value[key]
    delete!(d.key_to_value, key)
    delete!(d.value_to_key, value)
end

function Base.delete!(d::BiDict{K,V}, value::V) where {K,V}
    key = d.value_to_key[value]
    delete!(d.key_to_value, key)
    delete!(d.value_to_key, value)
end

function Base.length(d::BiDict{K,V}) where {K,V}
    length(d.value_to_key)
end


BiDict{K,V}() where {K,V} = BiDict(Dict{K,V}(), Dict{V,K}())

