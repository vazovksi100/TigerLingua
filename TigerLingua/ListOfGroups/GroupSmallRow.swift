//
//  GroupSmallRow.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI
import RealmSwift


struct GroupSmallRow: View {
        
    @ObservedObject var vm: GroupRowVM
        
    var body: some View {
        ZStack {
            NavigationLink {
                GroupDetailView(vm: GroupDetailVM(group: vm.group), isTextFieldsShown: false)
                    .navigationBarBackButtonHidden()
            } label: {
                ZStack {
                    Rectangle()
                        .fill(Color.bgGreen)
                        .frame(height: 70)
                        .cornerRadius(20)
                        
                    
                    HStack {
                        Text(vm.group.nameOfGroup)
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                        Text("\(vm.group.words.count)")
                            .foregroundColor(.white)
                            .opacity(0.3)
                    }
                    .padding()
                }
            }
            .onAppear {
                vm.updateWords()
            }
        }
    }
}



class GroupRowVM: ObservableObject {
    
    @ObservedRealmObject var group: WordList
    @Published var wordsCount: Int
    
    init(group: WordList) {
        self.group = group
        wordsCount = group.words.count
    }
    
  
    func updateWords() {
        wordsCount = group.words.count
    }
}
