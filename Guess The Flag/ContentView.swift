//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Vito Borghi on 26/07/2023.
//

/*
 DONE - When you tap a flag, make it spin around 360 degrees on the Y axis.
 DONE - Make the other two buttons fade out to 25% opacity.
 DONE - Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!
 */

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var isGameOver = false
    @State private var gameOverTitle = ""
    @State private var questionsLeft = 8
    
    @State private var isAnimating = false
    @State private var animationY: [Double] = [0,0,0]
    @State private var animationX: [Double] = [0,0,0]
    @State private var opaqueAmounts : [Double] = [1,1,1]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location:  0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3, id: \.self) { number in
                        Button {
                            for index in 0..<opaqueAmounts.count{
                                if index != number {opaqueAmounts[index] = 0.25}
                                else {
                                    withAnimation{
                                        animationY[index] = 360
                                    }
                                }
                            }
                            
                            withAnimation {
                                isAnimating.toggle()
                            }
                                flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 10)
                                .opacity( isAnimating ? 1.0 : opaqueAmounts[number])
                                .accessibilityLabel(labels[countries[number]], default: "Unknown flag")
                            
                                .animation(.easeOut(duration: 0.5), value: opaqueAmounts)
                                .scaleEffect(isAnimating ? 1.5 : 1)
                                .rotation3DEffect(.degrees(animationX[number]), axis: (x:1, y: 0, z: 0))
                                .rotation3DEffect(.degrees(animationY[number]), axis: (x:0, y: 1, z: 0))
                        }
                    }
                }
                .frame( maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
        //score point
        .alert(scoreTitle, isPresented: $showingScore) { Button("OK") {
            withAnimation {
                for index in 0...2 {
                    animationX[index] = 360
                }
            }
            askQuestions()
            }
        }
        
        //game over
        .alert("GAME OVER", isPresented: $isGameOver) {
            Button("Restart", role: .cancel, action: resetGame)
        } message: { Text("Your score is \(score)") }
        

    }
    
    func flagTapped(_ number: Int) {
        
        isAnimating.toggle()
        
            if number == correctAnswer {
                scoreTitle = "Correct!\nThat's the flag of \(countries[number])"
                score += 1
            } else {
                scoreTitle = "Wrong!\nThat's the flag of \(countries[number]) "
                score -= 1
            }
        showingScore.toggle()
            animationY = [0,0,0]
            animationX = [0,0,0]

    }
    
    func askQuestions() {
        
        questionsLeft -= 1
        if questionsLeft == 0 {
            isGameOver.toggle()
        }
        else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        opaqueAmounts = [1,1,1]
    }
    
    func resetGame () {
        questionsLeft = 8
        score = 0
        isGameOver = false
        askQuestions()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
