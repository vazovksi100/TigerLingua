//
//  NewGroupView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct NewGroupView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = AddGroupViewModel()
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(.bgGreen)
            
            VStack {
                Text("New Group")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Name of group:")
                        .foregroundStyle(.white)
                    
                    TextField("Group Name", text: $vm.groupName)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(Color.white)
                        .tint(Color.black)
                        .textInputAutocapitalization(.never)
                    
                }
                .font(.subheadline)
                
                VStack {
                    Button("Save", action: {
                        vm.createNewGroup()
                        dismiss()
                    })
                    .foregroundColor(.semiGreen)
                    .buttonStyle(.bordered)
                    .padding()
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                }
            }
            .padding()
        }
    }
}
