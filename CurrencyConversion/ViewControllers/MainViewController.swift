//
//  MainViewController.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    var portalMask: UIView = UIView()
    var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var portalViewController: PortalViewController = PortalViewController()
    var touchPoint: CGPoint = CGPoint()
    var preTouchPoint: CGPoint = CGPoint()
    
    @IBOutlet weak var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPortalMenu()
        self.loadMainTable()
        self.view.isUserInteractionEnabled = true
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    func loadPortalMenu() {
        portalMask = UIView(frame: self.view.bounds)
        portalMask.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        portalMask.alpha = 0
        portalMask.isUserInteractionEnabled = true
        self.view.addSubview(portalMask)
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(togglePortal))
        portalMask.addGestureRecognizer(gr)
        portalViewController = CCStoryboard.viewController(identifier: "PortalViewController") as! PortalViewController
        let width = self.view.frame.size.width - 70
        portalViewController.view.frame = CGRect(x: -width, y: 0, width: width, height: self.view.frame.size.height)
        portalViewController.delegate = self
        self.view.addSubview(portalViewController.view)
        self.addChild(portalViewController)
        portalViewController.didMove(toParent: self)
    }
    
    func loadMainTable() {
        mainTable.rowHeight = 70;
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.allowsSelection = true
        mainTable.alwaysBounceVertical = false
        mainTable.showsVerticalScrollIndicator = false
    }
    
    func isPortalOpened() -> (Bool) {
        return portalViewController.view.frame.origin.x == 0;
    }

    @objc func handlePan(gr: UIPanGestureRecognizer) {
        view.endEditing(true)
        switch gr.state {
        case .began:
            touchPoint = preTouchPoint
            touchPoint = gr.location(in: self.view)
            break
        case .changed:
            preTouchPoint = touchPoint
            touchPoint = gr.location(in: self.view)
            let deltaX = touchPoint.x - preTouchPoint.x
            
            let view = portalViewController.view
            if var frame = view?.frame {
                var x = (frame.origin.x) + deltaX
                if x >= 0 { x = 0 }
                else if x <= -(frame.size.width) { x = -frame.size.width }
                
                if frame.origin.x != x {
                    frame.origin.x = x
                    frame.size.height = UIScreen.main.bounds.size.height
                    view?.frame = frame
                    portalMask.alpha = 1 - (-x / (frame.size.width))
                }
            }
            break
        case .ended:
            let deltaX = touchPoint.x - preTouchPoint.x
            var show: Bool
            if abs(deltaX) > 5 {
                show = deltaX > 0
            } else {
                show = portalViewController.view.frame.origin.x > portalViewController.view.frame.size.width / 2
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.portalViewController.view.frame.origin.x = show ? 0 : -(self.portalViewController.view.frame.size.width)
                self.portalViewController.view.frame.size.height = UIScreen.main.bounds.size.height
                self.portalMask.alpha = show ? 1 : 0;
            })
            break
        default:
            break
        }
    }
    
    @objc func togglePortal() {
        let show = portalViewController.view.frame.origin.x == -(portalViewController.view.frame.size.width)
        UIView.animate(withDuration: 0.3) {
            self.portalViewController.view.frame.origin.x = show ? 0 : -(self.portalViewController.view.frame.size.width);
            self.portalMask.alpha = show ? 1 : 0;
        }
    }
    
    @IBAction func didSelectMenu(_ sender: Any) {
        self.togglePortal()
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "mainCurrencyCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MainCurrencyCell
        let arrContext = selectedArray[indexPath.row].components(separatedBy: ",")
        if arrContext.count == 2 {
            cell.abbr.text = arrContext[1]
            cell.currencyName.text = arrContext[0]
            let img = UIImage(named: "\(String(cell.abbr.text!.prefix(3).lowercased())).png") ?? UIImage(named: "unknown.png")
            cell.flag.image = img
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedArray.count
    }
    
}

class MainCurrencyCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var abbr: UILabel!
    @IBOutlet weak var currencyName: UILabel!
}

extension MainViewController: PortalViewControllerDelegate {
    func didSelectCurrency(array: [String], timestamp: Date) {
        self.selectedArray = array
        mainTable.reloadData()
    }
}
