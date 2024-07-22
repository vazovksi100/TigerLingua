//
//  Model.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import RealmSwift


class WordList: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var nameOfGroup: String = ""
    @Persisted var words = RealmSwift.List<Word>()
    
    @Persisted var groupMainLanguage: String?
    @Persisted var groupLearningLanguage: String?
}


class Word: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var wordWeight: Int = 0
    @Persisted var wordValue: String = ""
    @Persisted var wordTranslation: String = ""
    
    @Persisted var wordValueLanguage: String?
    @Persisted var wordTranslationLanguage: String?
}


enum Language: String, CaseIterable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    case en, uk, cs, de, pl, it, es, fr, other
    
    var description: String {
        switch self {
        case .en:
           return "English"
        case .uk:
            return "Ukrainian"
        case .cs:
            return "Czech"
        case .de:
            return "Deutch"
        case .pl:
            return "Polish"
        case .it:
            return "Italian"
        case .es:
            return "Spanish"
        case .fr:
            return "French"
        case .other:
            return "Other"
        }
    }
}

