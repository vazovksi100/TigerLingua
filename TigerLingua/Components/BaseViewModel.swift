//
//  BaseViewModel.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

enum StatusView {
    case readyToDisplay
    case lastWord
    case fewWords
}

class BaseViewModel {
    @Binding var selectedWordList: WordList?
    
    @Published var currentCardIndex = 0
    @Published var correctAnswersCount = 0
    @Published var wordsToTraining = [Word]()
    @Published var status: StatusView
    @Published var prefix = UserDefaults.standard.integer(forKey: "wordsPerTraining")//
    
    init(selectedWordList: Binding<WordList?>) {
        self._selectedWordList = selectedWordList
        self.status = .readyToDisplay
        
    }
    
    func shuffleWords() {
        if let words = selectedWordList?.words.shuffled() {
            wordsToTraining = words.prefix(prefix).shuffled()
        }
        status = wordsToTraining.count > 2 ? .readyToDisplay : .fewWords
    }
}
