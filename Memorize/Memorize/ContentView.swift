//
//  ContentView.swift
//  Memorize
//
//  Created by Anjalee Narenthiren on 2022-05-31.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = EmojiGame()
    
    var body: some View {
        if (!EmojiGame.playGame)
        {
            // Display Level Menu
            ScrollView {
                VStack {
                    Text("MEMORY GAME 🥸 😍 🤯")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(hue: 0.668, saturation: 0.232, brightness: 0.858))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 12.0)
                    ForEach(viewModel.numPairsAtLevel.indices) {levelIndex in
                        HStack {
                            Text("Level \(levelIndex + 1)")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.gray)
                                .padding(16.0).onTapGesture {
                                    viewModel.jumpToLevel(level: levelIndex)
                                }
                            if (EmojiGame.levelIsLocked(levelIndex)) {
                                Text("🔒")
                                    .font(.title)
                                    .fontWeight(.heavy)
                            }
                        }
                    }
                }
            }
            .padding(.top, 21.0)
            
        } else {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]){
                        ForEach(viewModel.cards) {
                            card in
                            CardView(card: card).padding(5.0).aspectRatio(2.3/3, contentMode: .fit).onTapGesture {
                                viewModel.choose(card)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Text("Moves: " + String(viewModel.numMoves))
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.gray)
                    .padding([.leading, .bottom], 7.0)
                HStack {
                    Text("Menu")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.893, brightness: 0.351))
                        .padding([.leading, .bottom], 7.0).onTapGesture {
                            viewModel.goToLevelMenu()
                        }
                    if (EmojiGame.bestScoreForEachLevel[viewModel.levelNumber] < Int.max) {
                    Text("Best Score: " + String(EmojiGame.bestScoreForEachLevel[viewModel.levelNumber]))
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.gray)
                        .padding([.leading, .bottom], 7.0)
                    }
                }
                
                if (viewModel.levelState == .userDecidingToGoToNextLevel) {
                
                        Text("Next Level?")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.893, brightness: 0.351))
                            .padding([.leading, .bottom], 7.0).onTapGesture {
                                viewModel.goToNextLevel()
                            }
                    
                }
            }
        }
    }
}

struct CardView: View {
    var card : MemoryGame<String>.Card;
    let shape = RoundedRectangle(cornerRadius: 20)
    var body: some View {
        GeometryReader {geometry in
            ZStack{
                if card.isFaceUp {
                    shape.foregroundColor(.white)
                    if (card.isMatched) {
                        shape.strokeBorder(lineWidth: 3.0).foregroundColor(.blue)
                    } else {
                        shape.strokeBorder(lineWidth: 3.0).foregroundColor(.red)
                    }
                    
                    Text(card.content)
                        .font(.system(size: min(geometry.size.height,geometry.size.width) * 0.75))
                        .foregroundColor(Color.black)
                } else {
                    shape.foregroundColor(.red)
                }
            }
        }
    }
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light).previewInterfaceOrientation(.portrait)
        ContentView().preferredColorScheme(.dark).previewInterfaceOrientation(.landscapeLeft)
    }
}
