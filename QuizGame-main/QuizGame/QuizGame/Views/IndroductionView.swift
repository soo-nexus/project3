//
//  IndroductionView.swift
//  QuizGame
//
//  Created by Jonathan Soo on 10/5/2025.
//

import SwiftUI

struct IndroductionView: View {
    @AppStorage("correctAnswers") var correctAnswers: Int = 0
    @EnvironmentObject private var navigationState: NavigationState
    @State private var quiz: Quiz = .empty
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text(quiz.title)
                    .font(.primaryTitle)
                Text("4 questions")
                    .font(.primaryContent)
                Button("Start") {
                    navigationState.routes.append(
                        .mainNavigation(.question(quiz.questions, 0))
                    )
                }
                .buttonStyle(CustomButtonStyle())
            }
            .foregroundColor(.white)
            .padding()
        }
        .onAppear {
            do {
                let jsonData = questionMock.data(using: .utf8)!
                let decodedQuiz = try JSONDecoder().decode(Quiz.self, from: jsonData)
                quiz = decodedQuiz
            } catch {
                print(error)
            }
        }
        .onAppear {
            correctAnswers = 0
        }
    }
}

struct IndroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IndroductionView()
    }
}
