//
//  Routes.swift
//  QuizGame
//
//  Created by Jonathan Soo on 10/5/2025.
//

import Foundation

enum Routes: Hashable {
    case mainNavigation(QuizRoutes)
    
    enum QuizRoutes: Hashable {
        case question([Question], Int)
        case results(correctAnswers: Int, numberOfQuestions: Int)
    }
}
