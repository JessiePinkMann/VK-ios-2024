//
//  MainViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import UIKit
import Weather
import CurrentCity
import TicTacToe
import Fifteen
import MathGame

class MainViewController: UIViewController {

    private let tableView = UITableView()
    var miniAppCount = Int.random(in: 10...15)
    var isInteractiveMode = false
    var fontCache: [IndexPath: UIFont] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")
        setupButtons()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MiniAppCell.self, forCellReuseIdentifier: MiniAppCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupButtons() {
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = UIColor(named: "primaryBackground")
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)

        let buttonHalfMode = UIButton(type: .system)
        buttonHalfMode.setTitle("1/2 Mode", for: .normal)
        buttonHalfMode.addTarget(self, action: #selector(setHalfMode), for: .touchUpInside)

        let buttonEighthMode = UIButton(type: .system)
        buttonEighthMode.setTitle("1/8 Mode", for: .normal)
        buttonEighthMode.addTarget(self, action: #selector(setEighthMode), for: .touchUpInside)

        buttonHalfMode.translatesAutoresizingMaskIntoConstraints = false
        buttonEighthMode.translatesAutoresizingMaskIntoConstraints = false

        buttonContainer.addSubview(buttonHalfMode)
        buttonContainer.addSubview(buttonEighthMode)

        NSLayoutConstraint.activate([
            buttonContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            buttonHalfMode.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 20),
            buttonHalfMode.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 20),
            buttonEighthMode.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 20),
            buttonEighthMode.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -20)
        ])
    }

    @objc func setHalfMode() {
        isInteractiveMode = true
        UIView.animate(withDuration: 0.3) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    @objc func setEighthMode() {
        isInteractiveMode = false
        UIView.animate(withDuration: 0.3) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return miniAppCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MiniAppCell.identifier, for: indexPath) as! MiniAppCell

        let index = indexPath.section % MiniAppData.allApps.count
        let appData = MiniAppData.allApps[index]

        if fontCache[indexPath] == nil {
            fontCache[indexPath] = MiniAppData.fonts.randomElement()
        }

        cell.titleLabel.font = fontCache[indexPath]
        cell.configure(
            with: appData.title,
            imageName: appData.imageName,
            description: appData.description,
            isInteractive: isInteractiveMode
        )

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return isInteractiveMode ? screenHeight / 2 : screenHeight / 8
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.section % MiniAppData.allApps.count
        let appData = MiniAppData.allApps[index]

        if isInteractiveMode {
            switch appData.title {
            case "Math Game":
                navigationController?.pushViewController(MathGameViewController(), animated: true)
            case "Fifteen Puzzle":
                navigationController?.pushViewController(GameViewController(), animated: true)
            case "Tic Tac Toe":
                navigationController?.pushViewController(TicTacToeViewController(), animated: true)
            case "Current City":
                navigationController?.pushViewController(CurrentCityViewController(), animated: true)
            case "Weather":
                navigationController?.pushViewController(WeatherViewController(), animated: true)
            default:
                print("Tapped on Mini App \(appData.title)")
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
