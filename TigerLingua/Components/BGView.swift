//
//  BGView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//

import SwiftUI

struct BGView: View {
    var body: some View {
        Image("blurBG")
            .resizable()
            .overlay(content: {
                Rectangle()
                    .foregroundColor(.black.opacity(0.6))
            })
            .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BGView()
    }
}
