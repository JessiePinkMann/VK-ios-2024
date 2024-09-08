//
//  MathGameModel.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 07.09.2024.
//

import Foundation

class MathGameModel {
    var correctAnswer = 0
    var choiceArray: [Int] = Array(repeating: 0, count: 9)
    var firstNumber = 0
    var secondNumber = 0
    var thirdNumber = 0
    var difficulty = 100
    var score = 0

    func answerIsCorrect(answer: Int) {
        if answer == correctAnswer {
            score += 1
        } else {
            score -= 1
        }
    }

    func generateAnswers() {
        firstNumber = Int.random(in: 0...(difficulty / 3))
        secondNumber = Int.random(in: 0...(difficulty / 3))
        thirdNumber = Int.random(in: 0...(difficulty / 3))
        correctAnswer = firstNumber + secondNumber + thirdNumber

        var answerList = [Int]()
        for _ in 0..<8 {
            answerList.append(Int.random(in: 0...difficulty))
        }
        answerList.append(correctAnswer)
        choiceArray = answerList.shuffled()
    }
}
