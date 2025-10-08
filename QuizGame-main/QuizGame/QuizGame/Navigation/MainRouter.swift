//
//  MainRouter.swift
//  QuizGame
//
//  Created by Jonathan Soo on 10/5/2025.
//

import SwiftUI

struct MainRouter {
    let routes: Routes.QuizRoutes
    
    @ViewBuilder
    func configure() -> some View {
        switch routes {
        case .question(let questions, let questionNumber):
            QuestionView(questions: questions, questionNumber: questionNumber)
        case .results(let correctAnswers, let numberOfQuestions):
            ResultsView(correctAnswers: correctAnswers, numberOfQuestions: numberOfQuestions)
        }
    }
}
