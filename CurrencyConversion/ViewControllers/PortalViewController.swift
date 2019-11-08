//
//  PortalViewController.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

struct Section {
    let alphabet : String
    let countries : [String]
}

class PortalViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var portalTable: UITableView!
    weak var delegate: PortalViewControllerDelegate?
    var currencyArray: [Section] = []
    var selectedArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTableView()
    }

    override func didMove(toParent parent: UIViewController?) {
        
    }
    
    func loadTableView() {
        portalTable.delegate = self
        portalTable.dataSource = self
        portalTable.allowsSelection = true
        
        let path = Bundle.main.path(forResource: "currency_abbr", ofType: "txt")
        if let path = path {
            var contents: String
            do {
                contents = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
            } catch {
                contents = ""
            }
            
            let array = contents.components(separatedBy: "\n")
            let groupedDic = Dictionary(grouping: array, by: {String($0.prefix(1))})
            let keys = groupedDic.keys.sorted()
            currencyArray = keys.map {
                Section(alphabet: $0, countries: (groupedDic[$0]?.sorted())!)
            }
        }
    }
}

extension PortalViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "portalCurrencyCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PortalCurrencyCell
        let section = currencyArray[indexPath.section]
        let arrContext = section.countries[indexPath.row].components(separatedBy: ",")
        if arrContext.count == 2 {
            cell.abbr.text = arrContext[1]
            cell.currencyName.text = arrContext[0]
            let img = UIImage(named: "\(String(cell.abbr.text!.prefix(2).lowercased())).png") ?? UIImage(named: "unknown.png")
            cell.flag.image = img
            cell.check.image = selectedArray.contains("\(cell.currencyName.text!),\(String(describing: cell.abbr.text!))") ? UIImage(named: "checked.png") : UIImage(named: "unchecked.png")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray[section].countries.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return currencyArray.map{$0.alphabet}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currencyArray[section].alphabet
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = currencyArray[indexPath.section].countries[indexPath.row]
        if selectedArray.contains(selectedCurrency) {
            if let index = selectedArray.firstIndex(where: { $0 == selectedCurrency }) {
                selectedArray.remove(at: index)
            }
        } else {
            selectedArray.append(selectedCurrency)
        }
        self.portalTable.reloadSections([indexPath.section], with: .none)
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
