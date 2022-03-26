//
//  CustomLabel.swift
//  VKTestTask
//
//  Created by Yulia Popova on 26/3/2022.
//

import UIKit

final class CustomLabel: UILabel {

    // MARK: - Public Properties
    // MARK: - Private Properties
    // MARK: - Initializers
    init(titleText: String, fontSize: CGFloat) {
        
        super.init(frame: .zero)
        text = titleText
        textColor = UIColor.white
        backgroundColor = UIColor.init(red: 0 / 255, green: 119 / 255, blue: 255 / 255, alpha: 1.0)
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: fontSize)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
