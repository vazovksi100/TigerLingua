//
//  WriteWordView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct WriteWordView: View {
    
    @StateObject var vm: WriteWordVM
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            BGView()
            
            VStack {
                Text("Writing Words")
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
                                .opacity(index == vm.currentCardIndex ? 1 : 0.5)
                        }
                        
                        Text(vm.translateStatus)
                            .offset(y: screenSize().height >= 780 ? 140 : 100)
                            .font(.title3)
                            .foregroundColor(.white)
                            .animation(.spring(), value: 0.5)
                    }
                    
                    .padding()

                    TextField("Write Translation", text: $vm.translate)
                        .background(Rectangle()
                            .fill(Color.lightCoalBlack)
                            .frame(width: 300, height: 35)
                            .cornerRadius(10)
                        )
                        .foregroundColor(.white)
                        .frame(width: 280)
                        .autocorrectionDisabled(true)
                    
                    HStack {
                        CustomButtonView(
                            buttonIcon: "rectangle.portrait.and.arrow.right",
                            size: 40,
                            color: .ratingRed)
                        {
                            vm.check()
                            vm.close()
                            vm.skip()
                        }
                        .offset(x: -50, y: 30)
                        
                        CustomButtonView(
                            buttonIcon: "checkmark",
                            size: 30,
                            color: .ratingEmerald)
                        {
                            vm.checkTranslation()
                        }
                        .offset(x: 50, y: 30)
                    }
                }
                .padding(.top, 100)
                .padding(.bottom, vm.keyboardOffset - 100)
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
        
        .onAppear {
            vm.shuffleWords()
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
                vm.keyboardOffset = keyboardFrame.height
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                vm.keyboardOffset = 0
            }
        }
    }
}

class WriteWordVM: BaseViewModel, ObservableObject {
    
    @Published var translate = ""
    @Published var translateStatus = ""
    @Published var keyboardOffset: CGFloat = 0
    
    func check() {
        if currentCardIndex >= wordsToTraining.count - 1 || currentCardIndex == prefix {
            status = .lastWord
        }
    }
    
    func skip() {
        StorageManager.shared.updateWeight(of: wordsToTraining[currentCardIndex], isKnow: false)
        currentCardIndex += 1
        translateStatus = ""
        translate = ""
    }
    
    func checkTranslation() {
        check()
        
        if  wordsToTraining[currentCardIndex].wordTranslation.lowercased() == translate.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            StorageManager.shared.updateWeight(of:  wordsToTraining[currentCardIndex], isKnow: true)
            correctAnswersCount += 1
            translateStatus = ""
            withAnimation {
                currentCardIndex += 1
            }
            translate = ""
            VibrationManager.shared.vibrated(with: true)
            close()
        } else {
            VibrationManager.shared.vibrated(with: false)
            withAnimation {
                translateStatus = translate.isEmpty ? "Write Word Worning" : "Incorrect"
            }
        }
    }
    
    func close() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct CardView: View {
    
    @ObservedObject var viewModel: CardViewModel
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(Color.lightCoalBlack)
                .frame(width: 320, height: screenSize().height >= 780 ? 420 : 320)
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.lightGreen, lineWidth: 1)
                        .opacity(0.4)
                }
            
            
            
            VStack {
                
                Text(viewModel.word.wordValue)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
                
                if viewModel.translateIsShown {
                    Text(viewModel.word.wordTranslation)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                        .opacity(0.7)
                }
                
                
            }
            
            if !viewModel.translateIsShown {
                Button {
                    withAnimation {
                        viewModel.translateIsShown.toggle()
                    }
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                .foregroundColor(Color.lightGreen)
                .offset(y: screenSize().height >= 780 ? 180 : 140)
            }
        }
        
    }
}


class CardViewModel: ObservableObject {
 
    @Published var word: Word
    @Published var translateIsShown = false
    
    init(word: Word) {
        self.word = word
    }
}

