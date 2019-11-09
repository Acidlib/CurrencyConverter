//
//  PortalViewController.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

class PortalViewController: BaseViewController {
    
    @IBOutlet weak var portalTable: UITableView!
    weak var delegate: PortalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTableView()
    }
    
    func loadTableView() {
        portalTable.delegate = self
        portalTable.dataSource = self
        portalTable.allowsSelection = true
    }
}

extension PortalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return APIManager.shared.groupedAllCurrencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "portalCurrencyCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PortalCurrencyCell
        let elem = APIManager.shared.groupedAllCurrencyList[indexPath.section].countries[indexPath.row]
        cell.abbr.text = elem.abbr
        cell.currencyName.text = elem.currencyName
        let img = UIImage(named: "\(elem.abbr.lowercased()).png") ?? UIImage(named: "unknown.png")
        cell.flag.image = img
        cell.check.image = elem.selected ? UIImage(named: "checked.png") : UIImage(named: "unchecked.png")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIManager.shared.groupedAllCurrencyList[section].countries.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return APIManager.shared.groupedAllCurrencyList.map{$0.alphabet}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return APIManager.shared.groupedAllCurrencyList[section].alphabet
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = APIManager.shared.groupedAllCurrencyList[indexPath.section].countries[indexPath.row]
        APIManager.shared.didSelectCurrency(section:indexPath.section, entity: selectedCurrency)
        self.portalTable.reloadSections([indexPath.section], with: .none)
        self.delegate?.didSelectCurrency(array: [], timestamp: Date())
    }
}

class PortalCurrencyCell: UITableViewCell {
    @IBOutlet weak var abbr: UILabel!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
}

protocol PortalViewControllerDelegate: class {
    func didSelectCurrency(array: [String], timestamp: Date)
}
