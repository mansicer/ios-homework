/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreML
import NaturalLanguage

func getLanguage(text: String) -> NLLanguage? {
    NLLanguageRecognizer.dominantLanguage(for: text)
}

func getPeopleNames(text: String, block: (String) -> Void) {
    let tagger = NLTagger(tagSchemes: [.nameType])
    tagger.string = text
    let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
    
    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
        if tag == .personalName {
            block(String(text[tokenRange]))
        }
        return true
    }
}

func getSearchTerms(text: String, language: String? = nil, block: (String) -> Void) {
    let tagger = NLTagger(tagSchemes: [.lemma])
    tagger.string = text
    
    if let language = language {
        tagger.setLanguage(NLLanguage(language), range: text.startIndex..<text.endIndex)
    }
    
    let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
    
    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma, options: options) { tag, tokenRange in
        let token = String(text[tokenRange]).lowercased()
        if let tag = tag {
            let lemma = tag.rawValue.lowercased()
            block(lemma)
            if (lemma != token) {
                block(token)
            }
        } else {
            block(token)
        }
        return true
    }
}

func analyzeSentiment(text:String) -> Double? {
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
    tagger.string = text
    
    let (tag, _)  = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
    guard let sentiment = tag, let score = Double(sentiment.rawValue) else {
        return nil
    }
    return score
}

func getSentimentClassifier() -> NLModel? {
    return try! NLModel(mlModel: SentimentClassifier(configuration: MLModelConfiguration()).model)
}

func predictSentiment(text: String, sentimentClassifier: NLModel) -> String? {
    let label = sentimentClassifier.predictedLabel(for: text)
    return label
}

// ------------------------------------------------------------------
// -------  Everything below here is for translation chapters -------
// ------------------------------------------------------------------


let esCharToInt = loadCharToIntJsonMap(from: "esCharToInt")
let intToEnChar = loadIntToCharJsonMap(from: "intToEnChar")

let maxOutSequenceLength = 87
let startTokenIndex = 0
let stopTokenIndex = 1

func getSentences(text: String) -> [String] {
    let tokenizer = NLTokenizer(unit: .sentence)
    tokenizer.string = text
    let sentencRanges = tokenizer.tokens(for: text.startIndex..<text.endIndex)
    return sentencRanges.map { range in String(text[range]) }
}

func getEncoderInput(text: String) -> MLMultiArray? {
    // 1
    let cleanedText = text.filter { esCharToInt.keys.contains($0) }
    if cleanedText.isEmpty {
        return nil
    }
    // 2
    let vocabSize = esCharToInt.count
    let encoderIn = initMultiArray(shape: [NSNumber(value: cleanedText.count), 1, NSNumber(value: vocabSize)])
    // 3
    for (i, c) in cleanedText.enumerated() {
        encoderIn[i * vocabSize + esCharToInt[c]!] = 1
    }
    return encoderIn
}

func getDecoderInput(encoderInput: MLMultiArray) -> Es2EnCharDecoderInput {
    // 1
    let encoder = try! Es2EnCharEncoder(configuration: MLModelConfiguration())
    let encoderOut = try! encoder.prediction(encodedSeq: encoderInput, encoder_lstm_h_in: nil, encoder_lstm_c_in: nil)
    // 2
    let decoderIn = initMultiArray(
    shape: [NSNumber(value: intToEnChar.count)])
    // 3
    return Es2EnCharDecoderInput(encodedChar: decoderIn, decoder_lstm_h_in: encoderOut.encoder_lstm_h_out, decoder_lstm_c_in: encoderOut.encoder_lstm_c_out)

}

func spanishToEnglish(text: String) -> String? {
    guard let encoderIn = getEncoderInput(text: text) else {
        return nil
    }
    let decoderIn = getDecoderInput(encoderInput: encoderIn)
    
    let decoder = try! Es2EnCharDecoder(configuration: MLModelConfiguration())
    var translatedText: [Character] = []
    var doneDecoding = false
    var decodedIndex = startTokenIndex
    
    while !doneDecoding {
        decoderIn.encodedChar[decodedIndex] = 1
        let decoderOut = try! decoder.prediction(input: decoderIn)
        decoderIn.decoder_lstm_h_in = decoderOut.decoder_lstm_h_out
        decoderIn.decoder_lstm_c_in = decoderOut.decoder_lstm_c_out
        decoderIn.encodedChar[decodedIndex] = 0
        
        decodedIndex = argmax(array: decoderOut.nextCharProbs)
        if decodedIndex == stopTokenIndex {
            doneDecoding = true
        }
        else {
            translatedText.append(intToEnChar[decodedIndex]!)
        }
        if translatedText.count >= maxOutSequenceLength {
            doneDecoding = true
        }
    }
    return String(translatedText)
}
