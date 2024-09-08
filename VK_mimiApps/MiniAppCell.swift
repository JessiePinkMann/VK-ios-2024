//
//  MiniAppCell.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import UIKit

class MiniAppCell: UITableViewCell {

    static let identifier = "MiniAppCell"
    
    // Название мини-приложения
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Изображение (иконка) мини-приложения
    private let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25  // Делает изображение круглым
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Кнопка информации
    let infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let descriptionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor  // Цвет тени
        view.layer.shadowOpacity = 0.3  // Прозрачность тени
        view.layer.shadowOffset = CGSize(width: 2, height: 2)  // Смещение тени
        view.layer.shadowRadius = 4  // Радиус тени
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Всплывающая подсказка для описания
    private let descriptionBubble: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "primaryBubble")  // Применяем динамический цвет для подсказки
        label.textColor = UIColor(named: "descriptionText")  // Цвет текста для подсказки
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.alpha = 0  // Прячем подсказку по умолчанию
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var isBubbleVisible = false  // Для отслеживания видимости подсказки
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Возвращаем стандартный стиль выделения
        selectionStyle = .default
        
        contentView.addSubview(appImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoButton)
        
        // Добавляем контейнер и внутри него — всплывающую подсказку
        contentView.addSubview(descriptionContainer)
        descriptionContainer.addSubview(descriptionBubble)

        setupConstraints()
        
        // Настраиваем кнопку информации
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        // Скругляем углы всей ячейки и устанавливаем цвет фона
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(named: "primaryBackground")  // Применяем динамический цвет для фона
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Настройка ячейки
    func configure(with title: String, imageName: String, description: String, isInteractive: Bool) {
        titleLabel.text = title
        appImageView.image = UIImage(named: imageName)
        descriptionBubble.text = description
        
        // Включаем/выключаем интерактивность и эффект выделения
        if isInteractive {
            selectionStyle = .default  // Разрешаем выделение
            contentView.isUserInteractionEnabled = true  // Ячейка кликабельна
        } else {
            selectionStyle = .none  // Отключаем эффект клика
            contentView.isUserInteractionEnabled = false  // Ячейка не кликабельна
        }
    }
    
    // Настройка констрейнтов
    private func setupConstraints() {
        // Картинка (иконка) слева
        NSLayoutConstraint.activate([
            appImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            appImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            appImageView.widthAnchor.constraint(equalToConstant: 50),
            appImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Название в центре
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: appImageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Кнопка "i" чуть левее
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),  // Смещаем кнопку левее
            infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Всплывающая подсказка внутри контейнера
        NSLayoutConstraint.activate([
            descriptionContainer.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -10),
            descriptionContainer.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -5),
            descriptionContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            descriptionBubble.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor),
            descriptionBubble.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor),
            descriptionBubble.topAnchor.constraint(equalTo: descriptionContainer.topAnchor),
            descriptionBubble.bottomAnchor.constraint(equalTo: descriptionContainer.bottomAnchor)
        ])
    }

    // Показ/скрытие всплывающей подсказки
    @objc private func infoButtonTapped(_ sender: UIButton) {
        isBubbleVisible.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.descriptionBubble.alpha = self.isBubbleVisible ? 1 : 0
        }
        
        // Автоматическое скрытие подсказки через 3 секунды
        if isBubbleVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hideDescriptionBubble()
            }
        }
    }

    // Метод для скрытия подсказки
    private func hideDescriptionBubble() {
        if isBubbleVisible {
            UIView.animate(withDuration: 0.3) {
                self.descriptionBubble.alpha = 0
            }
            isBubbleVisible = false
        }
    }
    
    // Переопределяем метод hitTest для точного определения области, на которую нажал пользователь
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let infoButtonPoint = infoButton.convert(point, from: self)
        if infoButton.bounds.contains(infoButtonPoint) {
            return infoButton  // Если касание произошло по кнопке, передаем его только ей
        }
        return super.hitTest(point, with: event)
    }
}
