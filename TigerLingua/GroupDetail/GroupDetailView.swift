//
//  GroupDetailView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI
import RealmSwift

struct GroupDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: GroupDetailVM
    @State var isTextFieldsShown: Bool
    
    
    var body: some View {
        ZStack {
            BGView()
            VStack {
                
                VStack {
                    Text("\(vm.group.nameOfGroup)")
                        .foregroundStyle(.white)
                        .font(.system(size: 36, weight: .bold))
                        .frame(width: screenSize().width)
                        .padding(.top)
                }
                .overlay {
                    HStack(spacing: 10) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                        
                        Picker("", selection: $vm.sortingMethod) {
                            ForEach(WordSorting.allCases, id: \.self) { sortingOption in
                                Text(sortingOption.description)
                                    .foregroundColor(Color.white)

                            }
                        }
                        .tint(.white)
                        .foregroundColor(Color.white)
                        .labelsHidden()
                        
                        
                        Spacer()
                        
                        
                        Button {
                            withAnimation {
                                if isTextFieldsShown {
                                    vm.showOrHide()
                                    isTextFieldsShown = false
                                }
                                vm.isSearchShown.toggle()
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.white)
                        }
                        
                        Button {
                            if vm.isSearchShown {
                                vm.isSearchShown.toggle()
                            }
                            vm.showOrHide()
                            isTextFieldsShown.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(Color.white)
                                .rotationEffect(.degrees(vm.addNewWordIsPressed ? 40 : 0))
                                .animation(.easeIn, value: vm.addNewWordIsPressed)
                        }
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 20)
                }
                
                withAnimation {
                    VStack {
                        if vm.addNewWordIsPressed {
                            AddNewWordsView(viewModel: vm) {
                                vm.offsetMove = vm.addNewWordIsPressed ?  0 : -310
                                isTextFieldsShown.toggle()
                            }
                        }
                        
                        if vm.isSearchShown {
                            Text("")
                                .searchable(text: $vm.searchWord, placement: .navigationBarDrawer(displayMode: .always))
                        }
                        List {
                            ForEach(vm.search(by: vm.searchWord, in: vm.sortWords(group: vm.group, by: vm.sortingMethod)), id: \.id) { word in
                                
                                WordRow(
                                    viewModel: WordRowViewModel(word: word),
                                    height: word.wordValue.count > 30 ? 85 : 60)
                               
                                .swipeActions {
                                    Button(role: .destructive) {
                                        StorageManager.shared.deleteWord(word: word)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(Color.red)
                                    Button {
                                        vm.threaded(word: word)
                                        vm.prepareTextFields(word: word)
                                        vm.alertPresented.toggle()
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                    .tint(Color.gray)
                                }
                                .listRowBackground(Color.clear)
                                .alert("Edit", isPresented: $vm.alertPresented, actions: {
                                    TextField("Word", text: $vm.editingValue)
                                        .autocorrectionDisabled()
                                        .foregroundColor(.ratingEmerald)
                                    TextField("Translate", text: $vm.editingTranslation)
                                        .autocorrectionDisabled()
                                        .foregroundColor(.ratingEmerald)
                                    
                                    Button("Save", action: {
                                        StorageManager.shared.editWord(
                                            selectedWordRefOptional: vm.threadedWord,
                                            value: vm.editingValue,
                                            translation: vm.editingTranslation)
                                        
                                    })
                                    
                                    Button("Cancel", role: .cancel, action: {})
                                    
                                }, message: {
                                    Text("EditMessage")
                                })
                                
                            }
                        }
                        .listStyle(.plain)
                    }
                    .padding(.bottom, vm.addNewWordIsPressed ?  0 : -90)
                    .animation(.linear, value: vm.offsetMove)
                }
            }
        }
        .onAppear {
            if isTextFieldsShown {
                vm.showOrHide()
          }
        }
    }
}
