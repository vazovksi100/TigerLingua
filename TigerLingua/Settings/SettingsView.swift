//
//  SettingsView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//




import SwiftUI
import MessageUI


struct SettingsView: View {
    
    @State private var showingMailWithError = false
    @State private var showingMailWithSuggestion = false
    @State private var isAnimationShown = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BGView()
                
                Form {
                    Section {
                        Button {
                            showingMailWithError.toggle()
                        } label: {
                            Text("Report a bug")
                        }
                        .sheet(isPresented: $showingMailWithError) {
                            MailComposeView(isShowing: $showingMailWithError, subject: "Error message", recipientEmail: "agnesschulz06@gmail.com", textBody: "")
                        }
                        
                        Button {
                            showingMailWithSuggestion.toggle()
                        } label: {
                            Text("Suggest improvement")
                        }
                        .sheet(isPresented: $showingMailWithSuggestion) {
                            MailComposeView(isShowing: $showingMailWithSuggestion, subject: "Improvement suggestion", recipientEmail: "agnesschulz06@gmail.com", textBody: "")
                        }
                    } header: {
                        Text("Support")
                            .foregroundColor(Color.gray)
                    }
                    .listRowBackground(Color.lightCoalBlack)
                    
                    Section {
                        Button {
                            openPrivacyPolicy()
                        } label: {
                            Text("Privacy Policy")
                        }
                    } header: {
                        Text("Usage")
                            .foregroundColor(Color.gray)
                    }
                    .listRowBackground(Color.lightCoalBlack)
         
                    Section {
                        Text("Delete all data")
                            .contextMenu {
                                Button {
                                  //  StorageManager.shared.deleteAllData()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        fatalError("closed when deleted")
                                    }
                                } label: {
                                    VStack {
                                        Text("Yes, I want to delete all data. The App will restart")
                                        Text("You will need to resrart the app")
                                    }
                                    
                                        
                                }
                                
                                Button {
                                    
                                } label: {
                                    Text("No, I changed my mind")
                                }
                            }
                            .foregroundColor(Color.red)
                    } header: {
                        Text("Danger zone")
                            .foregroundColor(Color.red)
                    } footer: {
                        Text("Long press for action")
                            .foregroundColor(Color.gray)
                    }
                    .listRowBackground(Color.lightCoalBlack)
                    
                }
                .tint(.white)
                .modifier(FormBackgroundModifier())
            }
            //MARK: - NavBar
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        VStack {
                            HStack(spacing: 10) {
                                
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .foregroundColor(.white)
                                
                                Text("Settings")
                                    .font(.system(size: 28, weight: .black))
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                            }
                            
                        }
                        Spacer()
                    }
                    .ignoresSafeArea()
                }
            }
        }
   
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
}


struct FormBackgroundModifier: ViewModifier {
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let subject: String
    let recipientEmail: String
    let textBody: String
    var onComplete: ((MFMailComposeResult, Error?) -> Void)?
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject(subject)
        mailComposer.setToRecipients([recipientEmail])
        mailComposer.setMessageBody(textBody, isHTML: false)
        mailComposer.mailComposeDelegate = context.coordinator
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isShowing = false
            parent.onComplete?(result, error)
        }
    }
}
