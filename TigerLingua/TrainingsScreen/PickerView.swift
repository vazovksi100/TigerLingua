//
//  PickerView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct PickerView: View {
    
    @ObservedObject var viewModel: TrainingsScreenViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Group")
                .font(.title3)
                .foregroundColor(.lightWhite)
                .bold()
            HStack {
                VStack(alignment: .leading) {
                    Picker("Choose List", selection: $viewModel.selectedWordList) {
                        ForEach(viewModel.wordList, id: \.id) { list in
                            Text(list.nameOfGroup)
                                .tag(list as WordList?)
                        }
                    }
                    .tint(.semiGreen)
                    .buttonStyle(.bordered)
                    
                }
               
                NavigationLink {
                    if let selectedList = viewModel.selectedWordList {
                        GroupDetailView(vm: GroupDetailVM(group: selectedList), isTextFieldsShown: true)
                            .navigationBarBackButtonHidden()
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.semiGreen)
                }


            }
            
        }
        .padding(.leading, 25)
    }
}

