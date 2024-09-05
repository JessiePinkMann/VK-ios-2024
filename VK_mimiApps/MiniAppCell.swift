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
    private let titleLabel: UILabel = {
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
    private let infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Всплывающая подсказка для описания
    private let descriptionBubble: UILabel = {
        let label = UILabel()
        label.backgroundColor = .darkGray
        label.textColor = .white
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
        contentView.addSubview(descriptionBubble)

        setupConstraints()
        
        // Настраиваем кнопку информации
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        // Скругляем углы всей ячейки
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
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
        
        // Кнопка "i" справа
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Всплывающая подсказка сверху справа
        NSLayoutConstraint.activate([
            descriptionBubble.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -10),
            descriptionBubble.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -5),
            descriptionBubble.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
    }
    
    // Показ/скрытие всплывающей подсказки
    @objc private func infoButtonTapped() {
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
}
