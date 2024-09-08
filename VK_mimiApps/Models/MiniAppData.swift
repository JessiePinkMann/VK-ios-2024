//
//  MiniAppData.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 08.09.2024.
//

import UIKit

struct MiniAppData {
    let title: String
    let imageName: String
    let description: String

    static let allApps: [MiniAppData] = [
        MiniAppData(title: "Math Game", imageName: "MathImg", description: " Solve math problems by adding three numbers together! "),
        MiniAppData(title: "Fifteen Puzzle", imageName: "FifteenImg", description: " Arrange the numbers in order by sliding them into the empty space. "),
        MiniAppData(title: "Tic Tac Toe", imageName: "TicTacToeImg", description: " Play a classic game of Tic Tac Toe against another player! "),
        MiniAppData(title: "Current City", imageName: "CurrentCityImg", description: " Find out your current city and view it on the map! "),
        MiniAppData(title: "Weather", imageName: "WeatherImg", description: " Get the current weather forecast for your location! ")
    ]

    static let fonts: [UIFont] = [
        UIFont(name: "AmericanTypewriter-Bold", size: 20)!,
        UIFont(name: "Chalkduster", size: 18)!,
        UIFont(name: "Papyrus", size: 22)!,
        UIFont(name: "Courier", size: 18)!,
        UIFont(name: "MarkerFelt-Wide", size: 24)!,
        UIFont(name: "Noteworthy-Bold", size: 20)!,
        UIFont(name: "SnellRoundhand-Black", size: 22)!,
        UIFont(name: "Verdana-Bold", size: 18)!,
        UIFont.systemFont(ofSize: 20, weight: .heavy),
        UIFont.systemFont(ofSize: 21, weight: .thin)
    ]
}
