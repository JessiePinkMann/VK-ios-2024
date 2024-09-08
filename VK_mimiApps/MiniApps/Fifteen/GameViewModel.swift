//
//  GameViewModel.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import Foundation

class GameViewModel {
    
    var tokens: [Token] = []
    var movesCount: Int = 0
    
    init() {
        startGames()
    }
    
    func startGames() {
        tokens = [
            Token(id: 1, number: 4, isEmpty: false),
            Token(id: 2, number: 7, isEmpty: false),
            Token(id: 3, number: 5, isEmpty: false),
            Token(id: 4, number: 8, isEmpty: false),
            Token(id: 5, number: 1, isEmpty: false),
            Token(id: 6, number: 2, isEmpty: false),
            Token(id: 7, number: 6, isEmpty: false),
            Token(id: 8, number: 0, isEmpty: true),
            Token(id: 9, number: 3, isEmpty: false)
        ]
        movesCount = 0
    }
    
    func move(token: Token) {
        guard !token.isEmpty else { return }
        let emptyIndex = tokens.firstIndex { $0.isEmpty } ?? 0
        let tokenIndex = tokens.firstIndex(of: token) ?? 0
        
        if isNear(first: tokenIndex, second: emptyIndex) {
            tokens.swapAt(tokenIndex, emptyIndex)
            movesCount += 1
        }
    }
    
    func isGameFinished() -> Bool {
        
        let correctOrder = [1, 2, 3, 4, 5, 6, 7, 8, 0]
        let currentOrder = tokens.map { $0.number }
        
        return currentOrder == correctOrder
    }
    
    private func isNear(first: Int, second: Int) -> Bool {
        let diff = abs(first - second)
        return diff == 1 || diff == 3
    }
}
