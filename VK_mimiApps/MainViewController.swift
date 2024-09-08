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

    // Переключение в режим 1/2 (интерактивные ячейки) с анимацией
    @objc func setHalfMode() {
        isInteractiveMode = true
        UIView.animate(withDuration: 0.3) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()  // Здесь мы применяем изменения с анимацией
        }
    }

    // Переключение в режим 1/8 (только просмотр) с анимацией
    @objc func setEighthMode() {
        isInteractiveMode = false
        UIView.animate(withDuration: 0.3) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()  // Здесь мы применяем изменения с анимацией
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    // Теперь количество секций равно количеству мини-приложений
    func numberOfSections(in tableView: UITableView) -> Int {
        return miniAppCount  // Каждая ячейка будет в отдельной секции
    }

    // В каждой секции только одна строка (ячейка)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  // В каждой секции только одна строка
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MiniAppCell.identifier, for: indexPath) as! MiniAppCell
        
        // Проверка по `indexPath.section`, чтобы каждая секция отображала свое приложение
        switch indexPath.section {
        case 0:
            cell.configure(
                with: "Math Game",
                imageName: "MathImg",  // Имя изображения из ассетов
                description: " Solve math problems by adding three numbers together! ",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        case 1:
            cell.configure(
                with: "Fifteen Puzzle",
                imageName: "FifteenImg",  // Имя изображения из ассетов
                description: " Arrange the numbers in order by sliding them into the empty space. ",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        case 2:
            cell.configure(
                with: "Tic Tac Toe",
                imageName: "TicTacToeImg",  // Имя изображения из ассетов
                description: " Play a classic game of Tic Tac Toe against another player! ",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        case 3:
            cell.configure(
                with: "Current City",
                imageName: "CurrentCityImg",  // Имя изображения из ассетов
                description: " Find out your current city and view it on the map! ",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        case 4:
            cell.configure(
                with: "Weather",
                imageName: "WeatherImg",  // Имя изображения из ассетов
                description: " Get the current weather forecast for your location! ",
                isInteractive: isInteractiveMode  // Интерактивность зависит от режима
            )
        default:
            cell.configure(
                with: "Mini App \(indexPath.section + 1)",
                imageName: "DefaultImage",  // Замените это на любое другое изображение
                description: "Description for Mini App \(indexPath.section + 1)",
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

    // Настройка высоты футера для создания отступов между секциями
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10  // Высота отступа между секциями
    }

    // Создаем кастомный `UIView` для футера секции
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear  // Можно сделать его прозрачным для создания визуального отступа
        return footerView
    }

    // Убираем заголовки секций
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01  // Минимальная высота заголовка секции, чтобы убрать отступ
    }

    // Обработка нажатия на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInteractiveMode {
            switch indexPath.section {
            case 0:
                let mathGameVC = MathGameViewController()
                navigationController?.pushViewController(mathGameVC, animated: true)
            case 1:
                let fifteenGameVC = GameViewController()  // Инициализируем контроллер игры Fifteen Puzzle
                navigationController?.pushViewController(fifteenGameVC, animated: true)
            case 2:
                let ticTacToeVC = TicTacToeViewController()  // Инициализируем контроллер игры Tic Tac Toe
                navigationController?.pushViewController(ticTacToeVC, animated: true)
            case 3:
                let currentCityVC = CurrentCityViewController()  // Инициализируем контроллер Current City
                navigationController?.pushViewController(currentCityVC, animated: true)
            case 4:
                let weatherVC = WeatherViewController()  // Инициализируем контроллер Weather
                navigationController?.pushViewController(weatherVC, animated: true)
            default:
                print("Tapped on Mini App \(indexPath.section + 1)")
            }
            
            // Снимаем выделение сразу после того, как пользователь отпустит ячейку
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
