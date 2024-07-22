//
//  SplittingView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct SplittingView: View {
    
    var arrayCharacter: [Character]
    var completion: (Character) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(arrayCharacter, id: \.self) { char in
                        Text(String(char))
                        .foregroundColor(Color.lightWhite)
                            .frame(width: 37, height: 45)
                            .background(Color.lightCoalBlack)
                            .cornerRadius(8)
                            .font(.title)
                            .onTapGesture {
                                completion(char)
                            }
                }
            }
            
        }
        .frame(width: 280)
    }
}

