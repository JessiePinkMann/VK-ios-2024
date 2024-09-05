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
    private let movesLabel = UILabel()  // Лейбл для отображения количества ходов
    private let restartButton = UIButton(type: .system)  // Кнопка Restart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white  // Сделаем фон белым, чтобы не было черного экрана
        setupUI()
        setupCollectionView()
        updateMovesLabel()  // Обновляем счетчик ходов при старте
    }
    
    private func setupUI() {
        let titleView = TitleView(text: "Fifteens")
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        movesLabel.text = "Moves made: \(viewModel.movesCount)"
        movesLabel.font = UIFont.systemFont(ofSize: Constants.smallTitle, weight: .regular)
        view.addSubview(movesLabel)
        movesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка кнопки Restart
        restartButton.setTitle("Restart", for: .normal)
        restartButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.smallTitle, weight: .bold)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка констрейнтов для всех элементов
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            movesLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Constants.padding),
            movesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // Настройка коллекции для токенов
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
        collectionView.backgroundColor = .clear  // Чтобы фон коллекции не был черным
        collectionView.register(TokenCollectionViewCell.self, forCellWithReuseIdentifier: TokenCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        
        // Настройка констрейнтов для коллекции
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: movesLabel.bottomAnchor, constant: Constants.padding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            collectionView.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -Constants.padding)
        ])
    }
    
    // Обновляем текст лейбла с количеством ходов
    private func updateMovesLabel() {
        movesLabel.text = "Moves made: \(viewModel.movesCount)"
    }
    
    // Перезапуск игры по нажатию кнопки Restart
    @objc private func restartGame() {
        viewModel.startGames()
        collectionView.reloadData()
        updateMovesLabel()  // Обновляем счетчик ходов
    }
    
    // Показ алерта по завершении игры
    private func showGameOverAlert() {
        let alert = UIAlertController(title: "Congratulations!", message: "You completed the puzzle in \(viewModel.movesCount) moves!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.restartGame()  // Перезапуск игры после завершения
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
        updateMovesLabel()  // Обновляем количество ходов при перемещении
        collectionView.reloadData()
        
        // Проверяем, завершена ли игра
        if viewModel.isGameFinished() {
            print("Game finished!")  // Отладочный вывод
            showGameOverAlert()  // Показываем сообщение о победе
        }
    }
}
