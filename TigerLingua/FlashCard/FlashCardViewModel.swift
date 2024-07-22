//
//  FlashCardViewModel.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI
import RealmSwift


class FlashCardViewModel: BaseViewModel, ObservableObject {
    
    @Published var index = 0
    
    func updateIndex() {
        index += 1
        if index == wordsToTraining.count || index == prefix {
            status = .lastWord
        }
    }
}



