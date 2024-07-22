//
//  TabMainView.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct TabMainView: View {
    
    init() {
           UITabBar.appearance().isHidden = true
       }
    
    @State private var isTabBarShown = true
    @State private var actibeTab: Tab = .home
    
    var body: some View {
        NavigationView {
            ZStack {
                BGView()
                
                TabView(selection: $actibeTab) {
                    TrainingsScreen(viewModel: TrainingsScreenViewModel())
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(Tab.home)
                    
                    WordsView()
                    .navigationBarHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                    .tag(Tab.words)
                    
                    SettingsView()
                    .navigationBarHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                    .tag(Tab.settings)
                }
                
                
            }
            .overlay {
                if isTabBarShown {
                    VStack {
                        Spacer()
                        TabBarView(tab: $actibeTab)
                            .toolbar(.hidden, for: .tabBar)
                            .padding(.horizontal)
                            .ignoresSafeArea()
                    }
                }
                
            }
        }
        .onAppear {
            DataManager.shared.createInitialList()
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct TabBarView: View {
    
    @Binding var tab: Tab
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.bgGreen)
                .shadow(color: .green.opacity(0.4), radius: 20, x: 0, y: 20)
            
            TabsLayoutView(selectedTab: $tab)
                .toolbar(.hidden, for: .tabBar)
                .navigationBarHidden(true)
        }
        .frame(height: 70, alignment: .center)
        .padding(.bottom, 10)
    }
}

fileprivate struct TabsLayoutView: View {
    @Binding var selectedTab: Tab
    @Namespace var namespace
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            ForEach(Tab.allCases) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                    .toolbar(.hidden, for: .tabBar)
                    .frame(width: 65, height: 65, alignment: .center)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarHidden(true)
                Spacer(minLength: 0)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
    }
    
    
    
    private struct TabButton: View {
        let tab: Tab
        @Binding var selectedTab: Tab
        var namespace: Namespace.ID
        
        var body: some View {
            Button {
                withAnimation {
                    selectedTab = tab
                }
            } label: {
                ZStack {
                    if isSelected {
                        Circle()
                            .foregroundColor(.bgGreen)
                            .shadow(radius: 10)
                            .background {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(.green.opacity(0.7))
                                
                            }
                            .offset(y: -25)
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                            .animation(.spring(), value: selectedTab)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                        .scaleEffect(isSelected ? 1 : 0.8)
                        .offset(y: isSelected ? -25 : 0)
                        .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
                }
            }
            .buttonStyle(.plain)
        }
        
        private var isSelected: Bool {
            selectedTab == tab
        }
    }
}


enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case home, words, settings
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .words:
            return "line.horizontal.3"
        case .settings:
            return "gearshape.2"
        }
    }
}
