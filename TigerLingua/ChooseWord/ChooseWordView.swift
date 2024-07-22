//
//  ChooseWordView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct ChooseWordView: View {
    
    @StateObject var vm: ChooseWordVM
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack(alignment: .top) {
            BGView()
            
            VStack {
                Text("Creating Words")
                    .font(.system(size: 36, weight: .bold))
                    .frame(width: screenSize().width)
                    .padding(.top)
                    .foregroundStyle(.white)
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
                    Spacer()
                    ZStack {
                        ForEach(Array(vm.wordsToTraining.enumerated()), id: \.1.id) { index, word in
                            CardView(viewModel: CardViewModel(word: word))
                                .offset(x: index == vm.currentCardIndex ? 0 : 500)
                                .opacity(index == vm.currentCardIndex ? 1 : 0.5)
                        }
                        
                    }
                    .padding()
                    
                    AnswerButtonsView(answerButtons: $vm.answers) { index in
                        vm.checkAnswer(index)
                    }
                    Spacer()
                }
            case .lastWord:
                FinishView(correctAnswersCount: vm.correctAnswersCount) {
                    dismiss()
                }
            case .fewWords:
                WarningView {
                    dismiss()
                }
            }
        }
        .gesture(
            TapGesture()
                .onEnded { _ in
                    if vm.isAnswerWrong {
                        self.vm.check()
                        self.vm.generate()
                    }
                }
        )
        .onAppear {
            vm.shuffleWords()
            vm.generate()
        }
    }
}


class ChooseWordVM: BaseViewModel, ObservableObject {
 
    @Published var answers = [String]()
    @Published var correctIndex = 0
    @Published var isAnswerWrong = false
    
    func generate() {
        if status == .readyToDisplay  {
            isAnswerWrong = false
            let correctAnswer = wordsToTraining[currentCardIndex].wordTranslation
            var options = wordsToTraining.map{$0.wordTranslation}.shuffled()
            options.removeAll(where: { $0 == correctAnswer })
            options.shuffle()
            correctIndex = Int.random(in: 0..<min(options.count, 3))
            answers = Array(options.prefix(3)) + [correctAnswer]
            answers.swapAt(correctIndex, answers.count-1)
        }
    }
    
    func check() {
        if currentCardIndex >= wordsToTraining.count - 1 || currentCardIndex == prefix {
            status = .lastWord
        } else {
            withAnimation {
                currentCardIndex += 1
            }
            generate()
        }
    }
    
    func checkAnswer(_ selectedButtonIndex: Int) {
        if isAnswerWrong {
            return
        }
                
        if selectedButtonIndex == correctIndex {
            StorageManager.shared.updateWeight(of: wordsToTraining[currentCardIndex], isKnow: true)
            answers[selectedButtonIndex] = "✅ " + answers[selectedButtonIndex]
            correctAnswersCount += 1
            check()
            VibrationManager.shared.vibrated(with: true)
            generate()
            return
        } else {
            StorageManager.shared.updateWeight(of: wordsToTraining[currentCardIndex], isKnow: false)
            answers[selectedButtonIndex] = "❌ " + answers[selectedButtonIndex]
            answers[correctIndex] = "🟢 " + answers[correctIndex]
            isAnswerWrong = true
            VibrationManager.shared.vibrated(with: false)
        }
    }
}


struct AnswerButtonsView: View {
    
    @Binding var answerButtons: [String]
    var completion: (Range<Int>.Element) -> Void
    
    var body: some View {
        VStack {
            ForEach($answerButtons.indices, id: \.self) { index in
                Button {
                    completion(index)
                } label: {
                    Text(answerButtons[index])
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 280, height: 25)
                }
            }
            .background(Color.black)
            .cornerRadius(8)
            .buttonStyle(.bordered)
            
        }
        
    }
}

