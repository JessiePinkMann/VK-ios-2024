//
//  TicTacToeModel.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 07.09.2024.
//

import Foundation

struct TicTacToeModel {
    var board: [String] = Array(repeating: "", count: 9)
    var currentPlayer: String = "X"
    var isActive: Bool = true
}
