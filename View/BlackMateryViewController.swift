//
//  ViewController.swift
//  VKTestTask
//
//  Created by Yulia Popova on 25/3/2022.
//

import UIKit

class BlackMateryViewController: UIViewController {
    
    private struct UIConstants {
        static let titleSize = 24.0
        static let textSize = 18.0
        static let tableViewPadding = 100.0
        static let stackPadding = 60.0
        static let rowHeight = 40.0
        static let stackHorisontalPadding = 20.0
    }
    
    enum TableSection: Int {
        case dataList
        case loader
    }

    private lazy var titleLabel = CustomLabel(titleText: "Dark Matter Viewer", fontSize: UIConstants.titleSize)
    
    private lazy var timeLabel = CustomLabel(titleText: "Time", fontSize: UIConstants.textSize)
    
    private lazy var measureLabel = CustomLabel(titleText: "Measure", fontSize: UIConstants.textSize)

    private lazy var tableView: UITableView = {
            let table = UITableView()
            table.backgroundColor = UIColor.AppColors.tableColor
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
        configureUI()
        fetchData()
    }
        
    private func configureUI() {
        
        view.backgroundColor = UIColor.AppColors.accentColor
        
        view.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.stackPadding).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [timeLabel, measureLabel])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        
        view.addSubview(stack)
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.stackHorisontalPadding).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -1 * UIConstants.stackHorisontalPadding).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.stackPadding).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.tableViewPadding).isActive = true
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.tableViewPadding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rowHeight = UIConstants.rowHeight
        
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

        guard let listSection = TableSection(rawValue: section) else {
            return 0
            
        }
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
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                let formatteddate = formatter.string(from: measurementElement.time)
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
