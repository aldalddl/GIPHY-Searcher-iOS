//
//  DeveloperViewController.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation
import UIKit
import SnapKit

class DeveloperViewController: UIViewController {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .regular)
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(DeveloperCell.self, forCellReuseIdentifier: DeveloperCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        layout()
    }
    
    func setUp() {
        self.view.backgroundColor = .background
        
        self.titleLabel.text = Developer.name
        self.descriptionLabel.text = Developer.description
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func layout() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(35)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}

extension DeveloperViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeveloperSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeveloperCell.id, for: indexPath) as? DeveloperCell else { return UITableViewCell() }
        
        guard let row = DeveloperSection(rawValue: indexPath.row) else { return UITableViewCell() }
        
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.desctiprion
        cell.imageView?.resizeImage(imageName: row.icon, newSize: CGSize(width: 30, height: 30))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = DeveloperSection(rawValue: indexPath.row) else { return }
        
        switch row {
        case .github:
            if let url = URL(string: row.source) {
                UIApplication.shared.open(url)
            }
        case .email:
            UIPasteboard.general.string = row.source
        }
    }
}
