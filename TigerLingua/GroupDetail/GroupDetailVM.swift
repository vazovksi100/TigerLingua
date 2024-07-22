//
//  GroupDetailVM.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI
import RealmSwift


class GroupDetailVM: ObservableObject {
    
    @ObservedRealmObject var group: WordList
    
    @Published var addNewWordIsPressed = false
    @Published var word = ""
    @Published var translate = ""
    @Published var warningText = ""
            
    @Published var alertPresented = false
    @Published var editingValue = ""
    @Published var editingTranslation = ""
    @Published var threadedWord: ThreadSafeReference<Word>?
    
    @Published var searchWord = ""
    @Published var isSearchShown = false
    
    @Published var offsetMove: CGFloat = -110
    @Published var sortingMethod: WordSorting = .unsorted
    
    
    func showOrHide() {
        addNewWordIsPressed.toggle()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        offsetMove = addNewWordIsPressed ?  0 : -110
    }
    
    func clearFields() {
        warningText = ""
        word = ""
        translate = ""
    }
    
    func checkTextFieldsAndSave() {
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTranslate = translate.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedWord.isEmpty && !trimmedTranslate.isEmpty else {
            warningText = "Fill Correct"
            return
        }
        
        saveNewWord(value: trimmedWord, translate: trimmedTranslate)
        VibrationManager.shared.vibrated(with: true)
        clearFields()
        
    }
    
    func saveNewWord(value: String, translate: String) {
        let newWord = Word()
        
        newWord.wordValue = UserDefaults.standard.bool(forKey: "upperCaseSwitcher") ? value : value.lowercased()
        newWord.wordTranslation = UserDefaults.standard.bool(forKey: "upperCaseSwitcher") ? translate : translate.lowercased()
        
        StorageManager.shared.saveWord(group: group, word: newWord)
    }
    
    func threaded(word: Word){
        threadedWord = ThreadSafeReference(to: word)
    }
    
    func prepareTextFields(word: Word) {
        editingValue = word.wordValue
        editingTranslation = word.wordTranslation
    }
    
    init(group: WordList, addNewWordIsPressed: Bool = false, word: String = "", transalte: String = "", warningText: String = "") {
        self.group = group
        self.addNewWordIsPressed = addNewWordIsPressed
        self.word = word
        self.translate = transalte
        self.warningText = warningText
    }

}


extension GroupDetailVM: ListSortable {
    
}


enum WordSorting: CaseIterable, CustomStringConvertible {
    
    case unsorted
    case alphabeticallyAscending
    case byWeightAscending
    case byWeightDescending
    
    var description: String {
           switch self {
           case .unsorted: return "○"
           case .alphabeticallyAscending: return "A-Z"
           case .byWeightAscending: return "1-10"
           case .byWeightDescending: return "10-1"
           }
       }
}

protocol ListSortable {
    func sortWords<T>(group: T, by sortingMethod: WordSorting) -> [Word]
    func search(by filterText: String, in group: [Word]) -> [Word]
}

extension ListSortable {
  
    func sortWords<T>(group: T, by sortingMethod: WordSorting) -> [Word] {
        
        let arrayForSort: [Word]
        
        switch group {
        case let list as WordList:
            arrayForSort = Array(list.words)
        case let results as Results<Word>:
            arrayForSort = Array(results)
        default:
            arrayForSort = []
        }
        
        switch sortingMethod {
        case .unsorted:
            return arrayForSort
        case .alphabeticallyAscending:
            return arrayForSort.sorted { $0.wordValue < $1.wordValue}
        case .byWeightAscending:
            return arrayForSort.sorted { $0.wordWeight < $1.wordWeight}
        case .byWeightDescending:
            return arrayForSort.sorted { $0.wordWeight > $1.wordWeight}
        }
    
    }
    
    func search(by filterText: String, in group: [Word]) -> [Word] {
        if filterText.isEmpty {
            return group
        } else {
            return group.filter {
                $0.wordValue.lowercased().contains(filterText.lowercased()) ||
                $0.wordTranslation.lowercased().contains(filterText.lowercased())
            }
        }
    }
  
}
