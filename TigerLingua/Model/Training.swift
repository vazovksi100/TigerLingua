//
//  Training.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI

struct Training {
    let trainingName: String
    let color: Color
    let image: String
    
    static func getViews() -> [Training] {
        [
            Training(trainingName: "Cards", color: .thinGreen, image: "flashCards"),
            Training(trainingName: "Choosing", color: .softViolet, image: "chooseWord"),
            Training(trainingName: "Creating", color: .softYellow, image: "makeWord"),
            Training(trainingName: "Writing", color: .softPeach, image: "writeWord")
        ]
    }
}
