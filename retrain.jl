include("src/testJukaiNLP.jl")
using testJukaiNLP

using Merlin: Graph, GraphNode, Embedding
using HDF5

using CPUTime

import Merlin: h5save, h5writedict, h5dict, h5convert

# engdoc = readconll("corpus/mini-training-set.conll",[2,11])

jpnTrainDoc = []
jpnTestDoc = []

push!(jpnTrainDoc,readknp("corpus/950101.KNP"))
push!(jpnTrainDoc,readknp("corpus/950103.KNP"))
push!(jpnTrainDoc,readknp("corpus/950104.KNP"))
push!(jpnTrainDoc,readknp("corpus/950105.KNP"))
push!(jpnTrainDoc,readknp("corpus/950106.KNP"))
push!(jpnTrainDoc,readknp("corpus/950107.KNP"))
push!(jpnTrainDoc,readknp("corpus/950108.KNP"))
push!(jpnTrainDoc,readknp("corpus/950109.KNP"))
push!(jpnTestDoc,readknp("corpus/950110.KNP"))
push!(jpnTrainDoc,readknp("corpus/950111.KNP"))
push!(jpnTrainDoc,readknp("corpus/950112.KNP"))
push!(jpnTrainDoc,readknp("corpus/950113.KNP"))
push!(jpnTrainDoc,readknp("corpus/950114.KNP"))
push!(jpnTrainDoc,readknp("corpus/950115.KNP"))
push!(jpnTrainDoc,readknp("corpus/950116.KNP"))
push!(jpnTrainDoc,readknp("corpus/950117.KNP"))

jpnTrainDoc = flattenDoc(jpnTrainDoc)
jpnTestDoc = flattenDoc(jpnTestDoc)

t = h5loadTokenizer("./tokenizer_20161006.h5")

#tAuto = TokenizerAutoEncode()
#tcuda = TokenizerCuda()

@time @CPUtime train(t, 1000, jpnTrainDoc, jpnTestDoc)

h5save("./tokenizer_20161006_add_1000.h5",t)