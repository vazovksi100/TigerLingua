//
//  CustomButtonView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI

struct CustomButtonView: View {
    
    var buttonIcon: String
    var size: CGFloat
    var color: Color
    var completion: () -> Void
    
    
    var body: some View {
        Button {
            completion()
        } label: {
            Rectangle()
                .frame(width: 80, height: 80)
                .cornerRadius(20)
                .foregroundColor(Color.lightCoalBlack)
                .overlay {
                    Image(systemName: buttonIcon)
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: size, height: size)
                }
        }
    }
}

