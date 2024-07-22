//
//  ComposingView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI

struct ComposingView: View {
    
    @Binding var answer: String
    var completion: () -> ()
    
    var body: some View {
        HStack {
            TextField("", text: $answer)
                .background(Rectangle()
                    .fill(Color.lightCoalBlack)
                    .frame(width: 250, height: 42)
                    .cornerRadius(10)
                            
                )
                .frame(width: 220)
                .foregroundColor(.white)
                .padding()
                .disabled(true)
            Button {
                completion()
            } label: {
                Image(systemName: "delete.left")
                    .foregroundColor(.white)
                    .font(.title)
            }
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(8)
            .buttonStyle(.bordered)
        }
    }
}
