//
//  SplitViewController.swift
//  TTS
//
//  Created by ์ํ์ฃผ on 2022/08/28.
//

import UIKit

class SplitVC: UISplitViewController {
    
    var tableLabels: [[String]] = [
        ["๐ ๊ฑฐ๋ ์์ฅ", "๐ต ํ๋งค ๋ฑ๋ก"],
        ["โธ๏ธ ์น์ธ ๋๊ธฐ ๋ชฉ๋ก", "๐งพ ๋ด ๊ฑฐ๋ ๋ด์ญ", "๐ ๊ฐ์ธ ์ ๋ณด"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredDisplayMode = .oneBesideSecondary
        
        if ProfileDB.shared.get().is_supplier {
            tableLabels = [
                ["๐ ๊ฑฐ๋ ์์ฅ", "๐ต ํ๋งค ๋ฑ๋ก"],
                ["โธ๏ธ ์น์ธ ๋๊ธฐ ๋ชฉ๋ก", "๐งพ ๋ด ๊ฑฐ๋ ๋ด์ญ", "๐ ๊ฐ์ธ ์ ๋ณด"]
            ]
        } else {
            tableLabels = [
                ["๐ ๊ฑฐ๋ ์์ฅ"],
                ["โธ๏ธ ์น์ธ ๋๊ธฐ ๋ชฉ๋ก", "๐งพ ๋ด ๊ฑฐ๋ ๋ด์ญ", "๐ ๊ฐ์ธ ์ ๋ณด"]
            ]
        }
        
        let menuVC = MenuController(style: .insetGrouped)
        menuVC.delegate = self
        
        //        let secondVC = UIViewController()
        let secondVC = HomeVC()
        //        secondVC.view.backgroundColor = .blue
//        secondVC.title = "ํ ํ๋ฉด"
        
        self.viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: secondVC)
        ]
    }
}

extension SplitVC: MenuControllerDelegate {
    func didTapMenuItem(at index: IndexPath, title: String?) {
        (self.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: false)
        var vc = UIViewController()
        vc.view.backgroundColor = .blue
        switch title {
        case "๐ ๊ฑฐ๋ ์์ฅ":
//            vc.title = "๊ฑฐ๋ ์์ฅ"
            vc = TradeVC()
        case "๐ต ํ๋งค ๋ฑ๋ก":
//            vc = SellVC(input: SellVC.Input(recBalance: 5000))
            vc = RecListVC()
        case "โธ๏ธ ์น์ธ ๋๊ธฐ ๋ชฉ๋ก":
            vc = ConfirmWaitVC()
        case "๐งพ ๋ด ๊ฑฐ๋ ๋ด์ญ":
//            vc.title = "๋ด ๊ฑฐ๋ ๋ด์ญ"
            if ProfileDB.shared.get().is_supplier {
                vc = SupplierInfoVC()
            } else {
                vc = BuyerInfoVC()
            }
        default:
            if ProfileDB.shared.get().is_supplier {
                vc = SupplierProfileVC(id: ProfileDB.shared.get().id)
            } else {
                vc = BuyerProfileVC(id: ProfileDB.shared.get().id)
            }
        }
        
        (self.viewControllers.last as? UINavigationController)?.pushViewController(vc, animated: true)
        
    }
}

protocol MenuControllerDelegate {
    func didTapMenuItem(at index: IndexPath, title:String?)
}

class MenuController: UITableViewController {
    
    var delegate: MenuControllerDelegate?
    var tableLabels: [[String]] = [
        ["๐ ๊ฑฐ๋ ์์ฅ", "๐ต ํ๋งค ๋ฑ๋ก", "โธ๏ธ ์น์ธ ๋๊ธฐ ๋ชฉ๋ก"],
        ["๐งพ ๋ด ๊ฑฐ๋ ๋ด์ญ", "๐ ๊ฐ์ธ ์ ๋ณด"]
    ]
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        title = "๋ฉ๋ด"
        
        if ProfileDB.shared.get().is_supplier {
            tableLabels = [
                ["๐ ๊ฑฐ๋ ์์ฅ", "๐ต ํ๋งค ๋ฑ๋ก", "โธ๏ธ ์น์ธ ๋๊ธฐ ๋ชฉ๋ก"],
                ["๐งพ ๋ด ๊ฑฐ๋ ๋ด์ญ", "๐ ๊ฐ์ธ ์ ๋ณด"]
            ]
        } else {
            tableLabels = [
                ["๐ ๊ฑฐ๋ ์์ฅ", "โธ๏ธ ์น์ธ ๋๊ธฐ ๋ชฉ๋ก"],
                ["๐งพ ๋ด ๊ฑฐ๋ ๋ด์ญ", "๐ ๊ฐ์ธ ์ ๋ณด"]
            ]
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "์ธ์ฆ์ ๊ฑฐ๋"
        default:
            return "๊ณ์  ๊ด๋ฆฌ"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableLabels[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableLabels[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellLabel = tableView.cellForRow(at: indexPath)?.textLabel?.text
        print("in selected \(indexPath.row)")
        delegate?.didTapMenuItem(at: indexPath, title: cellLabel)
    }
}
