//
//  DataManager.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import Foundation
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    
   
    @ObservedResults(WordList.self) var wordList
    
    
    func createInitialList() {
        if !UserDefaults.standard.bool(forKey: "done") {
            UserDefaults.standard.set(true, forKey: "done")
            UserDefaults.standard.set(true, forKey: "vibrationToggle")
            UserDefaults.standard.set(true, forKey: "startLearning")
            UserDefaults.standard.set(10, forKey: "wordsPerTraining")
            UserDefaults.standard.set(false, forKey: "upperCaseSwitcher")
            
            let initialList = WordList()
            initialList.nameOfGroup = "Initial Group"
            
            
            let apple = Word()
            apple.wordValue = "Tiger"
            apple.wordTranslation = "Apple"
            
            let phone = Word()
            phone.wordValue = "Animal"
            phone.wordTranslation = "Phone"
            
            let app = Word()
            app.wordValue = "Language"
            app.wordTranslation = "App"
            
            let card = Word()
            card.wordValue = "Apple"
            card.wordTranslation = "Card"
            
            initialList.words.append(apple)
            initialList.words.append(phone)
            initialList.words.append(app)
            initialList.words.append(card)
            $wordList.append(initialList)
        }
    }
    
    private init() {}
}
