//
//  ViewController.swift
//  VKTestTask
//
//  Created by Yulia Popova on 25/3/2022.
//

import UIKit

class BlackMateryViewController: UIViewController {
    
    enum TableSection: Int {
        case dataList
        case loader
    }

    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Dark Matter Viewer"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.init(red: 0 / 255, green: 119 / 255, blue: 255 / 255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        return label
    }()
    
    private lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()
    
    private lazy var measureLabel : UILabel = {
        let label = UILabel()
        label.text = "Measure"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()

    private lazy var tableView: UITableView = {
            let table = UITableView()
            table.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
            table.dataSource = self
            table.delegate = self
            
            table.translatesAutoresizingMaskIntoConstraints = false
            table.separatorStyle = .none
            return table
        }()

    private let pageLimit = 5
    private var currentLastId: Int? = nil
    
    private var data = [MeasurementModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
        
    private func setupView() {
        
        view.backgroundColor = UIColor.init(red: 0 / 255, green: 119 / 255, blue: 255 / 255, alpha: 1.0)
        
        view.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [timeLabel, measureLabel])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        
        view.addSubview(stack)
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.rowHeight = 40
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchData(completed: ((Bool) -> Void)? = nil) {
        DataManager.shared.getData() { [weak self] result in

            self?.data.append(contentsOf: result)
        }
    }
}

extension BlackMateryViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 8
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .dataList:
            return data.count
        case .loader:
            return data.count >= pageLimit ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        switch section {
            
            case .dataList:
                let measurementElement = data[indexPath.row]
            
                var formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            
                var formatteddate = formatter.string(from: measurementElement.time)
            
                cell.textLabel?.text = formatteddate
                cell.textLabel?.textColor = .label
                cell.detailTextLabel?.text = String(format: "%.3f", measurementElement.measurement)
            
            case .loader:
                cell.textLabel?.text = "Loading.."
                cell.textLabel?.textColor = .systemBlue
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !data.isEmpty else { return }
        
        if section == .loader {
            print("Loading new measurements..")
            fetchData { [weak self] success in
                if !success {
                    self?.hideBottomLoader()
                }
            }
        }
    }

    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.data.count - 1, section: TableSection.dataList.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}
