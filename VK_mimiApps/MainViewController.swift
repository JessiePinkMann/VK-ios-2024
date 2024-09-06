//
//  MainViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//
import UIKit

class MainViewController: UIViewController {

    private let tableView = UITableView()
    
    // Количество мини-приложений (будет сгенерировано случайное число от 5 до 15)
    var miniAppCount = Int.random(in: 5...15)
    
    // Переключатель между режимами
    var isInteractiveMode = false  // False - режим 1/8, True - режим 1/2

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")

        setupButtons()  // Сначала настраиваем кнопки
        setupTableView()  // Потом таблицу
    }

    // Настройка таблицы
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MiniAppCell.self, forCellReuseIdentifier: MiniAppCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none  // Убираем разделители между ячейками

        view.addSubview(tableView)

        // Авто-лейаут для таблицы, начиная под кнопками
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),  // Таблица начинается под кнопками
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // Настройка кнопок для переключения между режимами
    private func setupButtons() {
        // Создаем контейнер для кнопок
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = UIColor(named: "primaryBackground")  // Задаем фон контейнеру
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)
        
        // Создаем кнопки
        let buttonHalfMode = UIButton(type: .system)
        buttonHalfMode.setTitle("1/2 Mode", for: .normal)
        buttonHalfMode.addTarget(self, action: #selector(setHalfMode), for: .touchUpInside)
        
        let buttonEighthMode = UIButton(type: .system)
        buttonEighthMode.setTitle("1/8 Mode", for: .normal)
        buttonEighthMode.addTarget(self, action: #selector(setEighthMode), for: .touchUpInside)
        
        buttonHalfMode.translatesAutoresizingMaskIntoConstraints = false
        buttonEighthMode.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем кнопки в контейнер
        buttonContainer.addSubview(buttonHalfMode)
        buttonContainer.addSubview(buttonEighthMode)
        
        // Лейаут для контейнера кнопок
        NSLayoutConstraint.activate([
            buttonContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),  // Контейнер в самом верху
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 100)  // Высота контейнера
        ])
        
        // Лейаут для кнопок внутри контейнера
        NSLayoutConstraint.activate([
            buttonHalfMode.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 20),  // Поднимаем кнопки
            buttonHalfMode.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 20),
            
            buttonEighthMode.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 20),
            buttonEighthMode.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -20)
        ])
    }

    // Переключение в режим 1/2 (интерактивные ячейки)
    @objc func setHalfMode() {
        isInteractiveMode = true
        tableView.reloadData()
    }

    // Переключение в режим 1/8 (только просмотр)
    @objc func setEighthMode() {
        isInteractiveMode = false
        tableView.reloadData()
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miniAppCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MiniAppCell.identifier, for: indexPath) as! MiniAppCell
        
        // Пример для игры Math Game
        if indexPath.row == 0 {
            cell.configure(
                with: "Math Game",
                imageName: "MathImg",  // Имя изображения из ассетов
                description: "\n Solve math problems by adding three numbers together! \n",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        }
        // Пример для игры Fifteen Puzzle
        else if indexPath.row == 1 {
            cell.configure(
                with: "Fifteen Puzzle",
                imageName: "FifteenImg",  // Имя изображения из ассетов
                description: "\n Arrange the numbers in order by sliding them into the empty space. \n",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        }
        // Пример для игры Tic Tac Toe
        else if indexPath.row == 2 {
            cell.configure(
                with: "Tic Tac Toe",
                imageName: "TicTacToeImg",  // Имя изображения из ассетов (например, "TicTacToeImg")
                description: "\n Play a classic game of Tic Tac Toe against another player! \n",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        }
        else {
            cell.configure(
                with: "Mini App \(indexPath.row + 1)",
                imageName: "DefaultImage",  // Замените это на любое другое изображение
                description: "Description for Mini App \(indexPath.row + 1)",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        }

        return cell
    }

    // Меняем высоту ячеек в зависимости от режима
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if isInteractiveMode {
            return screenHeight / 2  // 1/2 экрана для интерактивного режима
        } else {
            return screenHeight / 8  // 1/8 экрана для режима просмотра
        }
    }

    // Обработка нажатия на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInteractiveMode {
            if indexPath.row == 0 {
                let mathGameVC = MathGameViewController()
                navigationController?.pushViewController(mathGameVC, animated: true)
            } else if indexPath.row == 1 {
                let fifteenGameVC = GameViewController()  // Инициализируем контроллер игры Fifteen Puzzle
                navigationController?.pushViewController(fifteenGameVC, animated: true)
            } else if indexPath.row == 2 {
                let ticTacToeVC = TicTacToeViewController()  // Инициализируем контроллер игры Tic Tac Toe
                navigationController?.pushViewController(ticTacToeVC, animated: true)
            } else {
                print("Tapped on Mini App \(indexPath.row + 1)")
            }
            
            // Снимаем выделение сразу после того, как пользователь отпустит ячейку
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
