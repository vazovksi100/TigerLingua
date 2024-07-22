//
//  SwipeCardView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct SwipeCardView: View {
    
    var width: CGFloat
    var height: CGFloat
    @StateObject var viewModel: SwipeCardViewModel
    @StateObject private var synthesizer = SpeechSynthesizer()
    var completion: () -> ()
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(viewModel.color)
                .frame(width: width, height: height)
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.lightGreen, lineWidth: 1)
                        .opacity(0.4)
                }

            HStack {
                if viewModel.isTranslated {
                    VStack {
                        Text(viewModel.word.wordTranslation)
                            .opacity(viewModel.isTranslated ? 1 : 0)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .rotation3DEffect(.degrees(Double(180)), axis: (x: 0, y: 1, z: 0))
                            .animation(.linear, value: viewModel.isTranslated)
                        Image(systemName: "speaker.wave.1.fill")
                            .foregroundColor(Color.lightGreen)
                            .rotation3DEffect(.degrees(Double(180)), axis: (x: 0, y: 1, z: 0))

                    }
                    .onTapGesture {
                        Task {
                            await synthesizer.speak(viewModel.word.wordTranslation)
                        }
                    }
                } else {
                    VStack {
                        Text(viewModel.word.wordValue)
                            .opacity(viewModel.isTranslated ? 0 : 1)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .animation(.linear, value: viewModel.isTranslated)
                        Image(systemName: "speaker.wave.1.fill")
                            .foregroundColor(Color.lightGreen)
                    }
                    .onTapGesture {
                        Task {
                            await synthesizer.speak(viewModel.word.wordValue)
                        }
                    }
                }
            }
            .multilineTextAlignment(.center)
            .frame(width: 250)
        }
        
        .rotation3DEffect(.degrees(Double(viewModel.rotation)), axis: (x: 0, y: 1, z: 0))
        .animation(.easeOut(duration: 0.4), value: viewModel.rotation)
        .onTapGesture {
            viewModel.rotation += 180
            viewModel.isTranslated.toggle()
        }
        .offset(x: viewModel.offset.width, y: viewModel.offset.height * 0.4)
        .rotationEffect(.degrees(Double(viewModel.offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    viewModel.offset = gesture.translation
                    withAnimation {
                        viewModel.changeColor(width: viewModel.offset.width)
                    }
                }
                .onEnded {_ in
                    withAnimation {
                        viewModel.swipeCard(width: viewModel.offset.width)
                        viewModel.changeColor(width: viewModel.offset.width)
                        viewModel.makeVibration(width: viewModel.offset.width)
                        if viewModel.isSwiped {
                            completion()
                        }
                    }
                }
        )
        
        
    }
}

