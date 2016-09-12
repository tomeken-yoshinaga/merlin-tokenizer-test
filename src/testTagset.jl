abstract Tagset

export encode

immutable IOE <: Tagset
  I::Int
  O::Int
  E::Int
end

IOE() = IOE(1,2,3)

function decode(tagset::IOE, tags::Vector{Int})
  bpos = 0
  ranges = UnitRange{Int}[]
  for i = 1:length(tags)
    t = tags[i]
    t != tagset.O && bpos == 0 && (bpos = i)
    if t == tagset.E
      push!(ranges, bpos:i)
      bpos = 0
    end
  end
  ranges
end

function encode(tagset::IOE, ranges::Vector{UnitRange{Int}})
  tags = fill(tagset.O, last(ranges[end]))
  for r in ranges
    tags[r] = tagset.I
    tags[last(r)] = tagset.E
  end
  tags
end
