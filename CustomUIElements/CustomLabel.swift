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
        backgroundColor = UIColor.AppColors.accentColor
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: fontSize)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
