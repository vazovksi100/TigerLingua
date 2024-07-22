//
//  TrainingsScreen.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//


import SwiftUI
import RealmSwift

struct TrainingsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: TrainingsScreenViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            BGView()
            
            VStack(alignment:.leading) {
                VStack {
                    Text("Tiger Lingua")
                        .foregroundColor(Color.lightWhite)
                        .font(smallScreen(isWidthCheck: false) ? .title : .largeTitle)
                        .bold()
                }
                .padding(.top, 10)
                .padding(.leading, 20)
                
                LazyVGrid(
                    columns: viewModel.lagreFixedColumns,
                    spacing: 10
                ) {
                    Section {
                        ForEach(viewModel.trainings, id: \.trainingName) { training in
                            
                            NavigationLink {
                                switch training.trainingName {
                                case "Cards" :
                                    FlashCardView(viewModel: FlashCardViewModel(selectedWordList: $viewModel.selectedWordList))
                                        .navigationBarBackButtonHidden()
                                case "Writing":
                                    WriteWordView(vm: WriteWordVM(selectedWordList: $viewModel.selectedWordList))
                                        .navigationBarBackButtonHidden()

                                case "Choosing":
                                    ChooseWordView(vm: ChooseWordVM(selectedWordList: $viewModel.selectedWordList))
                                        .navigationBarBackButtonHidden()

                                case "Creating":
                                    MakeWordView(vm: MakeWordVM(selectedWordList: $viewModel.selectedWordList))
                                        .navigationBarBackButtonHidden()

                                default:
                                    FlashCardView(viewModel: FlashCardViewModel(selectedWordList: $viewModel.selectedWordList))
                                        .navigationBarBackButtonHidden()

                                }
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.bgGreen)
                                        .frame(
                                            width: 175,
                                            height: 175)
                                        .cornerRadius(20)
                                        .shadow(radius: 10)
                                    VStack {
                                        Image(training.image)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            
                                        Text(training.trainingName)
                                            .foregroundColor(Color.white)
                                            .font(.title2)
                                            .bold()
                                    }
                                }
                            }
                        }
                    }
                    .offset(y: -15)
                }
                .padding(.horizontal)

                PickerView(viewModel: viewModel)
                
            }
        }
        .onAppear {
            viewModel.getFirstlist()
        }
    }
}


class TrainingsScreenViewModel: ObservableObject {
    
    
    @ObservedResults(WordList.self) var wordList
    @Published var selectedWordList: WordList?
    @Published var trainings = Training.getViews()
    
    let lagreFixedColumns: [GridItem] = [
        GridItem(.fixed(170), spacing: 15),
        GridItem(.fixed(170), spacing: 15)
    ]
    
    func getFirstlist() {
        if let firstWordList = wordList.first {
            selectedWordList = firstWordList
        }
    }
    
    init() {
        self.selectedWordList = wordList.first
    }
}

