//
//  FlashCardView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI

struct FlashCardView: View {
    @StateObject var viewModel: FlashCardViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BGView()
            
            VStack {
                Text("Cards")
                    .foregroundStyle(.white)
                    .font(.system(size: 36, weight: .bold))
                    .frame(width: screenSize().width)
                    .padding(.top)
                    .overlay {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading)
                    }
                
                Spacer()
            }
            
            
            switch viewModel.status {
            case .readyToDisplay:
                ZStack {
                    ForEach(viewModel.wordsToTraining, id: \.id) { word in
                        SwipeCardView(
                            width: 350,
                            height: 520,
                            viewModel: SwipeCardViewModel(word: word)) {
                                viewModel.updateIndex()
                            }
                    }
                }
            case .lastWord:
                ZStack {
                    VStack {
                        LottieEmptyStateView(fileName: "tiger")
                            .padding(.top, 100)
                            .padding(.bottom, -50)
                        VStack(alignment: .center) {
                            Spacer()
                            Text("You have completed the exercise!")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .bold()
                            
                            Button("Go back") {
                                dismiss()
                            }
                            .foregroundColor(Color.lightGreen)
                            .buttonStyle(.bordered)
                            .padding()
                            
                            Spacer()
                        }
                    }
                }
                
            case .fewWords:
                WarningView {
                    dismiss()
                }
            }
        }
        .onAppear {
            viewModel.shuffleWords()
        }
    }
}


