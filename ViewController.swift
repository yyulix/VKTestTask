//
//  ViewController.swift
//  VKTestTask
//
//  Created by Yulia Popova on 25/3/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementTableCell", for: indexPath) as! MeasurementTableCell
        cell.measurementLabel.text = "0.12432"
        cell.timestampLabel.text = "12.03.2011"

        return cell
    }

    private lazy var tableView: UITableView = {
        let table = UITableView()

        
        table.layer.cornerRadius = 30
        table.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
        table.register(MeasurementTableCell.self, forCellReuseIdentifier: "MeasurementTableCell")
        table.dataSource = self
        table.delegate = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Поиск темной материи"
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = .init(white: 1.0, alpha: 0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        self.view.backgroundColor = UIColor(patternImage: (UIImage(named: "background.jpeg"))!)
        layoutTableView()
    }
    
    private func layoutTableView() {
        
        view.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true

        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }

}

