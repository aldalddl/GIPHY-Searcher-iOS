//
//  SettingViewController.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/20/24.
//

import Foundation
import UIKit
import SnapKit

class SettingViewController: UIViewController {
    let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .background
        tableView.register(SettingDisclosureCell.self, forCellReuseIdentifier: SettingDisclosureCell.id)
        tableView.register(SettingInfoCell.self, forCellReuseIdentifier: SettingInfoCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        layout()
    }
    
    func setUp() {
        self.view.backgroundColor = .background
        
        self.navigationItem.title = "Setting"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
    }
    
    func layout() {
        self.view.addSubview(settingTableView)
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: UITableView DataSource
extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingSection(rawValue: section) else { return 0 }
        
        switch section {
        case .information:
            return Information.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .information:
            guard let row = Information(rawValue: indexPath.row) else { return UITableViewCell() }
            
            switch row {
            case .version:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingInfoCell.id, for: indexPath) as? SettingInfoCell else { return UITableViewCell() }
                cell.textLabel?.text = row.desctiprion
                cell.imageView?.image = UIImage(systemName: row.icon)
                return cell
            case .developer:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDisclosureCell.id, for: indexPath) as? SettingDisclosureCell else { return UITableViewCell() }
                cell.textLabel?.text = row.desctiprion
                cell.imageView?.image = UIImage(systemName: row.icon)
                return cell
            }
        }
    }
}

// MARK: UITableView Delegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let description = SettingSection(rawValue: section)?.headerDescription else { return UIView() }
        return SettingSectionHeaderView(description: description)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let description = SettingSection(rawValue: section)?.footerDescription else { return UIView() }
        return SettingSectionFooterView(description: description)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
