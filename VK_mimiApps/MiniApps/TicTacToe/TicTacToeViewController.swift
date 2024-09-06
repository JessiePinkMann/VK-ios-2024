//
//  TicTacToeViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 06.09.2024.
//
import UIKit

class TicTacToeViewController: UIViewController {

    private var board: [[UIButton]] = []  // Игровое поле с кнопками
    private var currentPlayer = "X"  // Начинаем с крестиков (Player 1)
    private var gameIsActive = true  // Флаг активности игры
    
    // Лейбл, отображающий текущий ход
    private let turnIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Now turn: Player 1 (X)"
        return label
    }()
    
    // Кнопка рестарта игры
    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(named: "buttonBackground")  // Цвет фона кнопки
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")
        
        setupUI()
        setupBoard()
        restartGame()  // Инициализируем поле при загрузке
    }

    private func setupUI() {
        // Добавляем лейбл с индикатором текущего игрока
        view.addSubview(turnIndicatorLabel)
        turnIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем кнопку рестарта
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Лейбл с индикатором хода вверху
            turnIndicatorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            turnIndicatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Кнопка рестарта внизу
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 120),
            restartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupBoard() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually  // Каждая строка будет равного размера
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: turnIndicatorLabel.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),  // Центрируем по горизонтали
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),  // Устанавливаем ширину поля 90% от ширины экрана
            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor)  // Высота равна ширине для квадратного поля
        ])
        
        // Создаем 3 ряда для 3x3 поля
        for _ in 0..<3 {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 10
            horizontalStack.distribution = .fillEqually  // Все ячейки равны
            
            var rowButtons: [UIButton] = []
            
            for _ in 0..<3 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
                button.setTitle("", for: .normal)  // Начинаем с пустых ячеек
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.black.cgColor
                button.backgroundColor = UIColor(named: "primaryBackground")  // Устанавливаем цвет фона для ячеек
                button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
                rowButtons.append(button)
                horizontalStack.addArrangedSubview(button)
            }
            
            board.append(rowButtons)
            stackView.addArrangedSubview(horizontalStack)
        }
    }


    // Логика перезапуска игры
    @objc private func restartGame() {
        for row in board {
            for button in row {
                button.setTitle("", for: .normal)
                button.isEnabled = true
            }
        }
        currentPlayer = "X"  // Начинаем с крестиков
        gameIsActive = true  // Активируем игру
        turnIndicatorLabel.text = "Now turn: Player 1 (X)"
    }

    // Обработка нажатия на ячейку
    @objc private func handleTap(_ sender: UIButton) {
        guard gameIsActive else { return }  // Если игра закончена, блокируем действия
        guard sender.title(for: .normal) == "" else { return }  // Если ячейка не пустая, игнорируем
        
        sender.setTitle(currentPlayer, for: .normal)  // Устанавливаем текущий символ
        checkForWinner()  // Проверяем на победителя
        
        if gameIsActive {
            switchPlayer()  // Если игра не окончена, переключаем игрока
        }
    }
    
    // Переключение хода
    private func switchPlayer() {
        currentPlayer = (currentPlayer == "X") ? "O" : "X"  // Меняем игрока
        let playerText = currentPlayer == "X" ? "Player 1 (X)" : "Player 2 (O)"
        turnIndicatorLabel.text = "Now turn: \(playerText)"
    }

    // Проверяем, есть ли победитель
    private func checkForWinner() {
        let winningCombinations = [
            [(0, 0), (0, 1), (0, 2)], // Верхняя строка
            [(1, 0), (1, 1), (1, 2)], // Средняя строка
            [(2, 0), (2, 1), (2, 2)], // Нижняя строка
            [(0, 0), (1, 0), (2, 0)], // Левая колонка
            [(0, 1), (1, 1), (2, 1)], // Средняя колонка
            [(0, 2), (1, 2), (2, 2)], // Правая колонка
            [(0, 0), (1, 1), (2, 2)], // Диагональ слева направо
            [(0, 2), (1, 1), (2, 0)]  // Диагональ справа налево
        ]
        
        for combination in winningCombinations {
            let (firstRow, firstCol) = combination[0]
            let (secondRow, secondCol) = combination[1]
            let (thirdRow, thirdCol) = combination[2]
            
            let firstTitle = board[firstRow][firstCol].title(for: .normal)
            let secondTitle = board[secondRow][secondCol].title(for: .normal)
            let thirdTitle = board[thirdRow][thirdCol].title(for: .normal)
            
            if firstTitle != "", firstTitle == secondTitle, firstTitle == thirdTitle {
                showWinnerAlert(player: currentPlayer)
                return
            }
        }
        
        // Если все ячейки заполнены и нет победителя — ничья
        let isBoardFull = board.flatMap({ $0 }).allSatisfy({ $0.title(for: .normal) != "" })
        if isBoardFull {
            showDrawAlert()
        }
    }

    // Показ алерта с победителем
    private func showWinnerAlert(player: String) {
        gameIsActive = false  // Отключаем активность игры
        let winner = player == "X" ? "Player 1 (X)" : "Player 2 (O)"
        let alert = UIAlertController(title: "Victory!", message: "\(winner) wins!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Показ алерта с ничьей
    private func showDrawAlert() {
        gameIsActive = false  // Отключаем активность игры
        let alert = UIAlertController(title: "Draw", message: "It's a draw!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
