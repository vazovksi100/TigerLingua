//
//  MakeWordView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct MakeWordView: View {
    
    @StateObject var vm: MakeWordVM
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack {
            BGView()
            
            VStack {
                Text("Creating Words")
                    .font(.system(size: 36, weight: .bold))
                    .frame(width: screenSize().width)
                    .foregroundStyle(.white)
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
            
            switch vm.status {
            case .readyToDisplay:
                VStack {
                    ZStack {
                        ForEach(Array(vm.wordsToTraining.enumerated()), id: \.1.id) { index, word in
                            CardView(viewModel: CardViewModel(word: word))
                                .offset(x: index == vm.currentCardIndex ? 0 : 500)
                                .opacity(index == vm.currentCardIndex ? 1 : 0.1)
                        }
                        
                        Text(vm.translateStatus)
                            .offset(y: screenSize().height >= 780 ? 140 : 100)
                            .font(.title3)
                            .foregroundColor(.white)
                            .animation(.spring(), value: 0.5)
                    }
                    
                    ComposingView(answer: $vm.answer) {
                        vm.returnChar()
                    }

                    
                    SplittingView(arrayCharacter: vm.arrayCharacter) { char in
                        vm.add(char: char)
                    }
                    
                    HStack {
                        CustomButtonView(
                            buttonIcon: "rectangle.portrait.and.arrow.right",
                            size: 40,
                            color: .ratingRed)
                        {
                            vm.skip()
                            vm.changeCard()
                        }
                        .offset(x: -50, y: 20)
                        
                        CustomButtonView(
                            buttonIcon: "checkmark",
                            size: 30,
                            color: .ratingEmerald)
                        {
                            vm.check()
                        }
                        .offset(x: 50, y: 20)
                    }
                }
            case .lastWord:
                FinishView(correctAnswersCount: vm.correctAnswersCount) {
                    dismiss()
                }
            case .fewWords:
                WarningView() {
                    dismiss()
                }
            }
        }
        .onAppear{
            vm.shuffleWords()
            vm.broke()
        }
    }
}



class MakeWordVM: BaseViewModel, ObservableObject {
    
    
    @Published var arrayCharacter: [Character] = []
    @Published var answer = ""
    @Published var translateStatus = ""
    
    func returnChar() {
        if !answer.isEmpty {
            let lastChar = answer.removeLast()
            arrayCharacter.append(lastChar)
        }
    }
    
    func changeCard() {
        if currentCardIndex >= wordsToTraining.count - 1 || currentCardIndex == prefix {
            status = .lastWord
        } else {
            answer = ""
            translateStatus = ""
            withAnimation {
                currentCardIndex += 1
            }
            broke()
        }
    }
    
    func skip() {
        StorageManager.shared.updateWeight(of: wordsToTraining[currentCardIndex], isKnow: false)
    }
    
    func check() {
        if answer == wordsToTraining[currentCardIndex].wordTranslation.lowercased() {
            StorageManager.shared.updateWeight(of: wordsToTraining[currentCardIndex], isKnow: true)
            correctAnswersCount += 1
            VibrationManager.shared.vibrated(with: true)
            changeCard()
        } else {
            VibrationManager.shared.vibrated(with: false)
            withAnimation {
                translateStatus = answer == "" ? "Make Word Warning" : "Incorrect"
            }
        }
    }
    
    func broke() {
        if wordsToTraining.count >= 3 {
            let correctAnswer = wordsToTraining[currentCardIndex].wordTranslation
            arrayCharacter = Array(correctAnswer.lowercased()).shuffled()
        } else {
            status = .fewWords
        }
    }
    
    func add(char: Character) {
        answer += String(char)
        arrayCharacter.remove(at: arrayCharacter.firstIndex(of: char) ?? 0)
    }
}
