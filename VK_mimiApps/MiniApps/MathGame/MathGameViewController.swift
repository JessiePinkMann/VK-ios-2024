//
//  MathGameViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//
import UIKit

class MathGameViewController: UIViewController {
    
    // Логические переменные игры
    var correctAnswer = 0
    var choiceArray: [Int] = Array(repeating: 0, count: 9)
    var firstNumber = 0
    var secondNumber = 0
    var thirdNumber = 0
    var difficulty = 100
    var score = 0
    
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
        view.backgroundColor = .white
        setupGameUI()
        generateAnswers()  // Начальная генерация примеров
    }

    // Настройка интерфейса игры
    private func setupGameUI() {
        // Добавляем label с уравнением
        view.addSubview(equationLabel)
        equationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            equationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),  // Центрируем ниже
            equationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Добавляем кнопки
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
                button.tag = rowIndex * 3 + columnIndex  // Индекс кнопки для дальнейшей логики
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                buttons.append(button)
                rowStackView.addArrangedSubview(button)
            }
            
            gridStackView.addArrangedSubview(rowStackView)
        }
        
        // Добавляем label с очками
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: gridStackView.bottomAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Добавляем бегунок сложности и label для него
        view.addSubview(difficultyLabel)
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            difficultyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(difficultySlider)
        NSLayoutConstraint.activate([
            difficultySlider.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 10),
            difficultySlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            difficultySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        // Добавляем таргет для изменения сложности
        difficultySlider.addTarget(self, action: #selector(difficultyChanged(_:)), for: .valueChanged)
    }

    // Логика изменения сложности
    @objc private func difficultyChanged(_ sender: UISlider) {
        difficulty = Int(sender.value)
        difficultyLabel.text = "Difficulty: \(difficulty)"
        // Не генерируем новый пример сразу, только обновляем сложность
    }

    // Логика нажатия на кнопку
    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        answerIsCorrect(answer: choiceArray[index])
        generateAnswers()  // Генерируем новый пример после ответа
    }
    
    private func answerIsCorrect(answer: Int) {
        if answer == correctAnswer {
            score += 1
        } else {
            score -= 1
        }
        updateUI()
    }
    
    // Генерация новых чисел и ответов
    private func generateAnswers() {
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
        updateUI()
    }
    
    // Обновление интерфейса
    private func updateUI() {
        equationLabel.text = "\(firstNumber) + \(secondNumber) + \(thirdNumber)"
        for (index, button) in buttons.enumerated() {
            button.setTitle("\(choiceArray[index])", for: .normal)
        }
        scoreLabel.text = "Score: \(score)"
    }
}
