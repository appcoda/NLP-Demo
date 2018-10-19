import NaturalLanguage
import CreateML
import Foundation

let text = "Evan Spiegel is the CEO of Snapchat! His biggest competition is from Instagram which is owned by Facebook Inc. lead by Mark Zuckerberg."
let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
let tags: [NLTag] = [.personalName, .organizationName, .placeName]

// 1
var socialTagScheme = NLTagScheme("Social")
var socialTag = NLTag("SOCIAL")

// 2
let modelURL = Bundle.main.url(forResource: "SocialMediaTagger", withExtension: "mlmodelc")!
let socialTaggerModel = try! NLModel(contentsOf: modelURL)

// 3
let socialTagger = NLTagger(tagSchemes: [.nameType, socialTagScheme])
socialTagger.setModels([socialTaggerModel], forTagScheme: socialTagScheme)

// 4
socialTagger.string = text
socialTagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { (tag, tokenRange) -> Bool in
    if let tag = tag, tags.contains(tag) {
        print("\(text[tokenRange]): \(tag.rawValue)")
    }
    return true
}

socialTagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: socialTagScheme, options: options) { (tag, tokenRange) -> Bool in
    if tag == socialTag {
        print("\(text[tokenRange]): SOCIAL")
    }
    return true
}
