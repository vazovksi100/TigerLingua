//
//  WordsView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI
import RealmSwift

struct WordsView: View {
    
    init() {
        UITextField.appearance().keyboardAppearance = .dark
    }
    
    @StateObject private var vm = WordsViewModel()

    var body: some View {
        ZStack {
            BGView()
            
            VStack {
                
                VStack {
                    
                    Text("Word Groups")
                        .foregroundStyle(.white)
                        .font(.system(size: 36, weight: .bold))
                        .frame(width: screenSize().width)
                }
                .padding(.top)
                
                .overlay {
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            vm.isNewViewShown.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(Color.semiGreen)
                                .font(.system(size: smallScreen(isWidthCheck: false) ? 15 : 20))
                        }
                        .sheet(isPresented: $vm.isNewViewShown) {
                            NewGroupView()
                                .background(Color.bgGreen)
                                .presentationDetents([.height(260)])
                                .presentationDragIndicator(.visible)
                        }
                    }
                    .padding(.trailing)
                }
                
                //MARK: - List of groups
                List {
                    ForEach(vm.groups.freeze(), id: \.id) { group in
                        GroupSmallRow(vm: GroupRowVM(group: group))
                            .swipeActions{
                                Button(role: .destructive) {
                                    vm.isLastGroup(group: group)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(Color.red)
                                
                                Button {
                                    vm.isNewViewShown.toggle()
                                } label: {
                                    Image(systemName: "pencil")
                                }
                                .sheet(isPresented: $vm.isNewViewShown) {
                                    NewGroupView()
                                        .presentationDetents([.medium, .large])
                                        .presentationDragIndicator(.visible)
                                }
                                .tint(Color.gray)
                            }
                            .listRowBackground(Color.clear)
                        //MARK: - Alert with Editing
                            .alert("Edit", isPresented: $vm.isEditing, actions: {
                                TextField("Enter Name Of Group", text: $vm.newValue)
                                    .autocorrectionDisabled()
                                    .foregroundColor(.ratingEmerald)
                                
                                Button("Save", action: {
                                    StorageManager.shared.updateGroup(
                                        selectedGroupRefOptional: vm.threadedGroup,
                                        newName: vm.newValue)
                                })
                                
                                Button("Cancel", role: .cancel, action: {})
                                    
                            })
                            
                    }
                }
                .scrollContentBackground(.hidden)
                .padding(.top, -10)
                .listStyle(.plain)
                .alert("Cant Delete Group", isPresented: $vm.alertPresented) {}
            }
        }
    }
}
