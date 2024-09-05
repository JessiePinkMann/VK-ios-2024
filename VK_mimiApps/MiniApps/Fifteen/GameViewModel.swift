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
    
    // Фиксированное начальное поле
    func startGames() {
        // Поле (1, пусто, 6), (7, 8, 3), (4, 2, 5)
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
    
    // Перемещение токена
    func move(token: Token) {
        guard !token.isEmpty else { return }
        let emptyIndex = tokens.firstIndex { $0.isEmpty } ?? 0
        let tokenIndex = tokens.firstIndex(of: token) ?? 0
        
        if isNear(first: tokenIndex, second: emptyIndex) {
            tokens.swapAt(tokenIndex, emptyIndex)
            movesCount += 1  // Увеличиваем счетчик ходов при успешном перемещении
        }
    }
    
    // Проверка, завершена ли игра
    func isGameFinished() -> Bool {
        // Проверка правильного порядка токенов
        let correctOrder = [1, 2, 3, 4, 5, 6, 7, 8, 0]  // Верное поле: 1-8, пустой токен (0)
        let currentOrder = tokens.map { $0.number }  // Текущий порядок токенов
        
        // Проверка, совпадает ли текущее поле с верным
        return currentOrder == correctOrder
    }
    
    // Проверка, находятся ли рядом пустой элемент и токен
    private func isNear(first: Int, second: Int) -> Bool {
        let diff = abs(first - second)
        return diff == 1 || diff == 3
    }
}
