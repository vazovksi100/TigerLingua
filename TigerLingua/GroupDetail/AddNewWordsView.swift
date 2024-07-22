//
//  AddNewWordsView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

enum Field {
    case word, translate
}

struct AddNewWordsView: View {
    
    @ObservedObject var viewModel: GroupDetailVM
    @FocusState var keyboardFocused: Field?
    var completion: () -> ()
    
    
    var body: some View {
        
        Group {
            VStack(alignment: .leading) {
                TextField("Word", text: $viewModel.word)
                    .focused($keyboardFocused, equals: .word)
                    .tint(Color.lightWhite)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .onSubmit {
                        keyboardFocused = .translate
                    }
                    
                TextField("Translate", text: $viewModel.translate)
                    .tint(Color.lightWhite)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($keyboardFocused, equals: .translate)
                    .onSubmit {
                        keyboardFocused = .word
                        viewModel.checkTextFieldsAndSave()
                    }
                Text(viewModel.warningText)
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if viewModel.addNewWordIsPressed {
                    HStack {
                        Button("Close") {
                            withAnimation {
                                viewModel.showOrHide()
                                viewModel.clearFields()
                            }
                            
                            completion()
                        }
                        .animation(.linear, value: viewModel.addNewWordIsPressed)
                        .foregroundColor(Color.ratingRed)
                        Spacer()
                        Button("Save") {
                            viewModel.checkTextFieldsAndSave()
                        }
                        .foregroundColor(Color.ratingEmerald)
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            keyboardFocused = .word
                        }
                    }
                }
            }
        }
    }
    
}
