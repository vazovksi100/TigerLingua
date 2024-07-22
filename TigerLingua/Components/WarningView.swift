//
//  WarningView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//

import SwiftUI

struct WarningView: View {
    
    var completion: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("Few Words")
                .font(.title)
                .foregroundColor(.white)
                .bold()
            
            VStack(alignment: .center) {
                
                Button("Go back") {
                    completion()
                }
                .foregroundColor(.lightGreen)
                .buttonStyle(.bordered)
                .padding()
            }
            Spacer()
        }
    }
}

