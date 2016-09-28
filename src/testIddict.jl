export IdDict
export load

type IdDict{T}
  key2id::Dict{T,Int}
  id2key::Vector{T}
  id2count::Vector{Int}

  IdDict() = new(Dict{T, Int}(), T[], Int[])
end

IdDict() = IdDict{Any}()

function IdDict{T}(data::Vector{T})
  d = IdDict{T}()
  for x in data
    push!(d, x)
  end
  d
end

function load(::Type{IdDict}, path)
  data = map(x -> chomp(x), open(radlines, path))
  IdDict(data)
end

Base.count(d::IdDict, id::Int) = d.id2count[id]

Base.getkey(d::IdDict, id::Int) = d.id2key[id]

Base.getindex(d::IdDict, key) = d.key2id[key]

Base.get(d::IdDict, key, default=0) = get(d.key2id, key, default)

Base.length(d::IdDict) = length(d.key2id)

function Base.push!(d::IdDict, key)
  if haskey(d.key2id, key)
    id = d.key2id[key]
    d.id2count[id] += 1
  else
    id = length(d.id2key) + 1
    d.key2id[key] = id
    push!(d.id2key, key)
    push!(d.id2count, 1)
  end
  id
end

function h5convert(f::IdDict)
    h5dict(IdDict, "key2id"=>f.key2id,
           "id2key"=>f.id2key, 
           "id2count"=>f.id2count)
end
