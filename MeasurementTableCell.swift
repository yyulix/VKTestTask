//
//  MeasurementTableCell.swift
//  VKTestTask
//
//  Created by Yulia Popova on 26/3/2022.
//

import UIKit

class MeasurementTableCell: UITableViewCell {

    lazy var measurementLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var timestampLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    
    private func configureStackView() {
        let stack = UIStackView(arrangedSubviews: [measurementLabel, timestampLabel])
        stack.axis = .horizontal
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureStackView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
