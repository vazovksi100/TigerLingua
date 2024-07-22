//
//  WordsViewModel.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import Foundation
import RealmSwift

class WordsViewModel: ObservableObject {
    @ObservedResults(WordList.self) var groups
    
    @Published var alertPresented = false
    @Published var addNewGroupPresented = false
    @Published var groupName = ""
    @Published var threadedGroup: ThreadSafeReference<WordList>?
    @Published var isEditing = false
    @Published var newValue = ""
    @Published var isNewViewShown = false

    func isLastGroup(group: WordList) {
        if groups.count > 1 {
            StorageManager.shared.deleteGroup(group: group)
        } else {
            VibrationManager.shared.vibrated(with: true)
            alertPresented.toggle()
        }
        objectWillChange.send()
    }

    func threadGroup(group: WordList){
        threadedGroup = ThreadSafeReference(to: group)
    }
    
    func prepareTF(group: WordList) {
        newValue = group.nameOfGroup
    }
}
