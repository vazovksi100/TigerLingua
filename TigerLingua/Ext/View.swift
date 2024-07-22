//
//  View.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

extension View {
    
    func screenSize() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
    
    func smallScreen(isWidthCheck: Bool) -> Bool {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
        
        if isWidthCheck {
            return window.screen.bounds.size.width <= 375
        } else {
            return window.screen.bounds.size.height <= 667
        }
    }
    
    func embedNavigationView(with title: String) -> some View {
        return NavigationStack {
            self
                .toolbarBackground(
                    Color.lightCoalBlack,
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.lightGreen)
                        
                    }
                }
        }
        
    }
}

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
