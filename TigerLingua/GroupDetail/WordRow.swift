//
//  WordRow.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI

struct WordRow: View {
    
    let viewModel: WordRowViewModel
    var height: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.bgGreen)
                .frame(height: height)
                .cornerRadius(15)
                .overlay {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.word.wordValue)
                                .foregroundColor(.white)
                                .font(.title2)

                            Text(viewModel.word.wordTranslation)
                                .foregroundColor(.white)
                                .font(.title2)
                                .opacity(0.5)
                                
                        }

                        Spacer()

                        RatingView(viewModel: viewModel)
                    }
                    .padding(.horizontal, 20)
                }
            
        }
    }
}


class WordRowViewModel: ObservableObject {
    
    let word: Word
    
    func getRatingColors(with rating: Int) -> [Color] {
        var colors: [Color] = []
        
        switch rating {
        case 0...2: colors = [.ratingRed]
        case 3: colors = [.ratingRed, .ratingYellow]
        case 4: colors = [.ratingRed, .ratingYellow, .ratingYellow]
        case 5: colors = [.ratingRed, .ratingYellow, .ratingYellow, .ratingYellow, .ratingGreen]
        case 6: colors = [.ratingYellow, .ratingYellow, .ratingYellow, .ratingGreen]
        case 7: colors = [.ratingYellow, .ratingYellow, .ratingGreen]
        case 8: colors = [.ratingYellow, .ratingGreen]
        case 9...10: colors = [.ratingGreen]
        default: break
        }
        
        return colors
    }
    
    init(word: Word) {
        self.word = word
    }
    
}
