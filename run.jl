include("./src/testJukaiNLP.jl")
using testJukaiNLP

using Merlin
using CPUTime

import Merlin: h5save, h5writedict, h5dict, h5convert

function doTest(trainData, validData, prefix::String, nepoch::Int, emboutCh::Int, convFilterWidth::Int;learningRate=0.0001, dynamicRate::Bool=false)

    success(`mkdir -p ./data/$(prefix)`)
    success(`mkdir -p ./model/$(prefix)`)

    t = Tokenizer(prefix,emboutCh=emboutCh,convFilterWidth=convFilterWidth)

    beginTime = time()
    @time @CPUtime train(t, nepoch, trainData, validData, learningRate=learningRate,dynamicRate=dynamicRate)
    endTime = time()

    outf = open("./data/$(prefix)/computeTime.txt","w")
    write(outf,"time:\t$(endTime - beginTime)")
    close(outf)

    h5save(string("./model/",prefix,"/tokenizer_result.h5"),t)
end

function accuracy(gold, test)
    totalGold = 0
    correctTest = 0
    for i = 1:length(gold)
        for j = 1:length(gold[i])
            gold[i][j] == test[i][j] && (correctTest += 1)
            totalGold += 1
        end
    end
    correctTest / totalGold
end

jpnTrainDoc = readCorpus("./corpus/jpnTrainDoc.h5")
jpnValidDoc = readCorpus("./corpus/jpnValidDoc.h5")
#jpnTestDoc = readCorpus( "./corpus/jpnTestDoc.h5")

println("Train data:\t($(length(jpnTrainDoc)))")
println("Valid data:\t($(length(jpnValidDoc)))")
#println("Test data:\t($(length(jpnTestDoc)))")

nepoch = 500
embCh = 32

prefix = "20161124/pattern1"
doTest(jpnValidDoc,jpnValidDoc,prefix, nepoch, embCh, 3)

prefix = "20161124/pattern2"
doTest(jpnValidDoc,jpnValidDoc,prefix, nepoch, embCh, 5)

prefix = "20161124/pattern3"
doTest(jpnValidDoc,jpnValidDoc,prefix, nepoch, embCh, 7)

prefix = "20161124/pattern4"
doTest(jpnValidDoc,jpnValidDoc,prefix, nepoch, embCh, 9)
