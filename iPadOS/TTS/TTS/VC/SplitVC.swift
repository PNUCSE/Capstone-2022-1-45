//
//  SplitViewController.swift
//  TTS
//
//  Created by 안현주 on 2022/08/28.
//

import UIKit

class SplitVC: UISplitViewController {
    
    var tableLabels: [[String]] = [
        ["📈 거래 시장", "💵 판매 등록"],
        ["⏸️ 승인 대기 목록", "🧾 내 거래 내역", "🔑 개인 정보"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredDisplayMode = .oneBesideSecondary
        
        if ProfileDB.shared.get().is_supplier {
            tableLabels = [
                ["📈 거래 시장", "💵 판매 등록"],
                ["⏸️ 승인 대기 목록", "🧾 내 거래 내역", "🔑 개인 정보"]
            ]
        } else {
            tableLabels = [
                ["📈 거래 시장"],
                ["⏸️ 승인 대기 목록", "🧾 내 거래 내역", "🔑 개인 정보"]
            ]
        }
        
        let menuVC = MenuController(style: .insetGrouped)
        menuVC.delegate = self
        
        //        let secondVC = UIViewController()
        let secondVC = HomeVC()
        //        secondVC.view.backgroundColor = .blue
//        secondVC.title = "홈 화면"
        
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
        case "📈 거래 시장":
//            vc.title = "거래 시장"
            vc = TradeVC()
        case "💵 판매 등록":
//            vc = SellVC(input: SellVC.Input(recBalance: 5000))
            vc = RecListVC()
        case "⏸️ 승인 대기 목록":
            vc = ConfirmWaitVC()
        case "🧾 내 거래 내역":
//            vc.title = "내 거래 내역"
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
        ["📈 거래 시장", "💵 판매 등록", "⏸️ 승인 대기 목록"],
        ["🧾 내 거래 내역", "🔑 개인 정보"]
    ]
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        title = "메뉴"
        
        if ProfileDB.shared.get().is_supplier {
            tableLabels = [
                ["📈 거래 시장", "💵 판매 등록", "⏸️ 승인 대기 목록"],
                ["🧾 내 거래 내역", "🔑 개인 정보"]
            ]
        } else {
            tableLabels = [
                ["📈 거래 시장", "⏸️ 승인 대기 목록"],
                ["🧾 내 거래 내역", "🔑 개인 정보"]
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
            return "인증서 거래"
        default:
            return "계정 관리"
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
