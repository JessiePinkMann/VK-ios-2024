//
//  MathGameViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//
import UIKit

class MathGameViewController: UIViewController {
    
    // Модель игры
    private var gameModel = MathGameModel()  // Логика вынесена в модель
    
    // UI элементы
    private let equationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Score: 0"
        return label
    }()
    
    private var buttons: [AnswerButton] = []
    
    // Бегунок сложности
    private let difficultySlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 10
        slider.maximumValue = 200
        slider.value = 100  // Стартовое значение сложности
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty: 100"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")
        setupGameUI()
        gameModel.generateAnswers()  // Начальная генерация примеров
        updateUI()
    }

    // Настройка интерфейса игры
    private func setupGameUI() {
        // Добавляем label с уравнением
        view.addSubview(equationLabel)
        equationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            equationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            equationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Добавляем сетку с кнопками
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 10
        gridStackView.alignment = .center
        view.addSubview(gridStackView)
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStackView.topAnchor.constraint(equalTo: equationLabel.bottomAnchor, constant: 30)
        ])
        
        for rowIndex in 0..<3 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            for columnIndex in 0..<3 {
                let button = AnswerButton()
                button.tag = rowIndex * 3 + columnIndex  // Индекс кнопки для логики
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                buttons.append(button)
                rowStackView.addArrangedSubview(button)
            }
            gridStackView.addArrangedSubview(rowStackView)
        }
        
        // Добавляем бегунок сложности и label для него
        view.addSubview(difficultyLabel)
        view.addSubview(difficultySlider)
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultySlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: gridStackView.bottomAnchor, constant: 20),
            difficultyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            difficultySlider.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 10),
            difficultySlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            difficultySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        // Добавляем label с очками под бегунком сложности
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: difficultySlider.bottomAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Добавляем таргет для изменения сложности
        difficultySlider.addTarget(self, action: #selector(difficultyChanged(_:)), for: .valueChanged)
    }

    // Логика изменения сложности
    @objc private func difficultyChanged(_ sender: UISlider) {
        gameModel.difficulty = Int(sender.value)
        difficultyLabel.text = "Difficulty: \(gameModel.difficulty)"
    }

    // Логика нажатия на кнопку
    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        gameModel.answerIsCorrect(answer: gameModel.choiceArray[index])
        gameModel.generateAnswers()
        updateUI()
    }

    // Обновление UI
    private func updateUI() {
        equationLabel.text = "\(gameModel.firstNumber) + \(gameModel.secondNumber) + \(gameModel.thirdNumber)"
        for (index, button) in buttons.enumerated() {
            button.setTitle("\(gameModel.choiceArray[index])", for: .normal)
        }
        scoreLabel.text = "Score: \(gameModel.score)"
    }
}
