//
//  QuestionView.swift
//  QuizGame
//
//  Created by Jonathan Soo on 10/5/2025.
//

import SwiftUI

enum AnswerType {
    case unvoted
    case correct
    case bad
}

struct QuestionView: View {
    @EnvironmentObject private var navigationState: NavigationState
    @AppStorage("circleProgress") var circleProgress: [Int: Bool] = [:]
    @AppStorage("correctAnswers") var correctAnswers: Int = 0
    @State private var selectedOption: String = ""
    @State private var selectedAnswer: AnswerType = .unvoted

    let questions: [Question]
    let questionNumber: Int

    private var limitedQuestions: [Question] {
        Array(questions.prefix(4))
    }
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 20) {
                
                // MARK: - Question Text
                Text(limitedQuestions[questionNumber].question)
                    .font(.primaryTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // MARK: - Answer Options
                VStack {
                    if limitedQuestions[questionNumber].options.count == 4 {
                        HStack {
                            optionButton(limitedQuestions[questionNumber].options[0])
                            optionButton(limitedQuestions[questionNumber].options[1])
                        }
                        HStack {
                            optionButton(limitedQuestions[questionNumber].options[2])
                            optionButton(limitedQuestions[questionNumber].options[3])
                        }
                    }
                }
                .padding(.vertical)
                
                // MARK: - Progress Circles
                HStack {
                    ForEach(0..<limitedQuestions.count, id: \.self) { index in
                        if index == questionNumber {
                            CircleIndicator(answear: $selectedAnswer)
                        } else if questionNumber > index {
                            if circleProgress[index] == true {
                                CircleIndicator(answear: .constant(.correct))
                            } else {
                                CircleIndicator(answear: .constant(.bad))
                            }
                        } else {
                            CircleIndicator(answear: .constant(.unvoted))
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding()
            .toolbar(.hidden)
        }
    }
    
    // MARK: - Option Button
    @MainActor
    private func optionButton(_ option: String) -> some View {
        Button {
            nextQuestion {
                selectedOption = option
                selectedAnswer = selectedOption == limitedQuestions[questionNumber].answer ? .correct : .bad
                if selectedAnswer == .correct {
                    correctAnswers += 1
                    circleProgress[questionNumber] = true
                } else {
                    circleProgress[questionNumber] = false
                }
            }
        } label: {
            Text(option)
                .frame(width: 150, height: 50)
                .minimumScaleFactor(0.5)
        }
        .padding(8)
        .disabled(!selectedOption.isEmpty)
        .ifElse(selectedOption == option) { view in
            view.buttonStyle(CustomButtonStyle(cornerRadius: 8,
                                               answerType: selectedAnswer))
        } elseTransform: { view in
            view
                .ifElse(option == limitedQuestions[questionNumber].answer && selectedAnswer != .unvoted) { view in
                    view.buttonStyle(CustomButtonStyle(cornerRadius: 8,
                                                       answerType: .correct))
                } elseTransform: { view in
                    view.buttonStyle(CustomButtonStyle(cornerRadius: 8))
                }
        }
    }
    
    // MARK: - Navigation Logic
    private func nextQuestion(action: @escaping () -> Void) {
        Task {
            action()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if questionNumber < limitedQuestions.count - 1 {
                navigationState.routes.append(.mainNavigation(.question(limitedQuestions, questionNumber + 1)))
            } else {
                navigationState.routes.append(
                    .mainNavigation(
                        .results(correctAnswers: correctAnswers,
                                 numberOfQuestions: limitedQuestions.count)
                    )
                )
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            QuestionView(questions: questionsArrayMock,
                         questionNumber: 0)
        }
    }
}
