//
//  TicTacToeViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 06.09.2024.
//

import UIKit

class TicTacToeViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var currentPlayer = "X"
    private var gameIsActive = true
    private var boardState = Array(repeating: "", count: 9)
    
    private let turnIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Now turn: Player 1 (X)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(named: "buttonBackground")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")
        setupUI()
        setupCollectionView()
    }

    private func setupUI() {
        view.addSubview(turnIndicatorLabel)
        view.addSubview(restartButton)
        
        NSLayoutConstraint.activate([
            turnIndicatorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            turnIndicatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 120),
            restartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TicTacToeCell.self, forCellWithReuseIdentifier: TicTacToeCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: turnIndicatorLabel.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            collectionView.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -20)
        ])
    }

    @objc private func restartGame() {
        boardState = Array(repeating: "", count: 9)
        currentPlayer = "X"
        gameIsActive = true
        turnIndicatorLabel.text = "Now turn: Player 1 (X)"
        collectionView.reloadData()
    }

    private func handleTap(at indexPath: IndexPath) {
        guard gameIsActive else { return }
        guard boardState[indexPath.item] == "" else { return }
        boardState[indexPath.item] = currentPlayer
        collectionView.reloadItems(at: [indexPath])
        checkForWinner()
        if gameIsActive { switchPlayer() }
    }

    private func switchPlayer() {
        currentPlayer = (currentPlayer == "X") ? "O" : "X"
        let playerText = currentPlayer == "X" ? "Player 1 (X)" : "Player 2 (O)"
        turnIndicatorLabel.text = "Now turn: \(playerText)"
    }

    private func checkForWinner() {
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        for combination in winningCombinations {
            let first = boardState[combination[0]]
            let second = boardState[combination[1]]
            let third = boardState[combination[2]]
            if first != "", first == second, first == third {
                showWinnerAlert(player: currentPlayer)
                return
            }
        }
        if !boardState.contains("") { showDrawAlert() }
    }

    private func showWinnerAlert(player: String) {
        gameIsActive = false
        let winner = player == "X" ? "Player 1 (X)" : "Player 2 (O)"
        let alert = UIAlertController(title: "Victory!", message: "\(winner) wins!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showDrawAlert() {
        gameIsActive = false
        let alert = UIAlertController(title: "Draw", message: "It's a draw!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension TicTacToeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicTacToeCell.identifier, for: indexPath) as! TicTacToeCell
        let symbol = boardState[indexPath.item]
        cell.configure(with: symbol)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleTap(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing * 2
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: width)
    }
}
