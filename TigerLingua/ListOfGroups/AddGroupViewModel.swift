//
//  AddGroupViewModel.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import Foundation
import RealmSwift

class AddGroupViewModel: ObservableObject {
    
    @ObservedResults(WordList.self) var wordGroups
    @Published var mainLanguage: Language = .other
    @Published var learnLanguage: Language = .other
    @Published var groupName = ""

    
    func createNewGroup() {
        let trimmedGroupName = groupName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedGroupName.isEmpty else {
            groupName = ""
            return
        }
        
        let newGroup = WordList()
        newGroup.nameOfGroup = groupName
        newGroup.groupMainLanguage = mainLanguage.rawValue
        newGroup.groupLearningLanguage = learnLanguage.rawValue
        
        $wordGroups.append(newGroup)
        groupName = ""
    }
}
