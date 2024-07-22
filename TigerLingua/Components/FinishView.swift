//
//  FinishView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct FinishView: View {
    
    var correctAnswersCount: Int
    var completion: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                LottieEmptyStateView(fileName: "tiger")
                    .padding(.top, 100)
                    .padding(.bottom, -50)
                VStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Text("Correct Answers")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        Text("\(correctAnswersCount)")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    }
                    Button("Go back") {
                        completion()
                    }
                    .foregroundColor(Color.lightGreen)
                    .buttonStyle(.bordered)
                    .padding()
                    Spacer()
                }
            }
        }
    }
}

