//
//  GameViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import UIKit

class GameViewController: UIViewController {
    
    private let viewModel = GameViewModel()
    private var collectionView: UICollectionView!
    private let movesLabel = UILabel()
    private let restartButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")
        setupUI()
        setupCollectionView()
        updateMovesLabel()
    }
    
    private func setupUI() {
        let titleView = TitleView(text: "Fifteens")
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        movesLabel.text = "Moves made: \(viewModel.movesCount)"
        movesLabel.font = UIFont.systemFont(ofSize: Constants.smallTitle, weight: .regular)
        view.addSubview(movesLabel)
        movesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        restartButton.setTitle("Restart", for: .normal)
        restartButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.smallTitle, weight: .bold)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            movesLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Constants.padding),
            movesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacing
        layout.minimumInteritemSpacing = Constants.spacing
        let itemSize = (view.frame.width - Constants.padding * 2 - Constants.spacing * 2) / 3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TokenCollectionViewCell.self, forCellWithReuseIdentifier: TokenCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: movesLabel.bottomAnchor, constant: Constants.padding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            collectionView.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -Constants.padding)
        ])
    }
    
    private func updateMovesLabel() {
        movesLabel.text = "Moves made: \(viewModel.movesCount)"
    }
    
    @objc private func restartGame() {
        viewModel.startGames()
        collectionView.reloadData()
        updateMovesLabel()
    }
    
    private func showGameOverAlert() {
        let alert = UIAlertController(title: "Congratulations!", message: "You completed the puzzle in \(viewModel.movesCount) moves!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tokens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCollectionViewCell.identifier, for: indexPath) as! TokenCollectionViewCell
        let token = viewModel.tokens[indexPath.item]
        cell.configure(with: token)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let token = viewModel.tokens[indexPath.item]
        viewModel.move(token: token)
        updateMovesLabel()
        collectionView.reloadData()
        
        if viewModel.isGameFinished() {
            print("Game finished!")
            showGameOverAlert()
        }
    }
}
