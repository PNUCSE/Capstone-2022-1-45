//
//  ConfirmViewController.swift
//  TTS
//
//  Created by 안현주 on 2022/09/08.
//

import UIKit
import Then
import SnapKit
import RxSwift

class ConfirmWaitVC: UIViewController {
    private var disposeBag = DisposeBag()
    private var viewModel = ConfirmVM()
    private var buyerRepository = BuyerRepository()
    private var supplierRepository = SupplierRepository()
    
    private var titleLabel = UILabel()
    
    lazy var confirmTableHeader = ConfirmHeader()
    lazy var confirmTable = UIScrollView()
    lazy var stackView = UIStackView()
    
    private var loadingIndicatorView = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setView()
    }
    
    func setView() {
        [titleLabel, confirmTableHeader, confirmTable, loadingIndicatorView].forEach {
            view.addSubview($0)
        }
        setTitle()
        setConfirmTable()
        setLoadingIndicView()
        setBinding()
    }
    
    func setTitle() {
        titleLabel.then {
            $0.text = "⏸️ 승인 대기 목록"
            $0.textColor = Const.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        }.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30.0)
            make.left.equalToSuperview().inset(10.0)
        }
    }
    
    func setLoadingIndicView() {
        loadingIndicatorView.then {
            $0.center = self.view.center
            $0.color = Const.Color.primary
            $0.startAnimating()
            $0.hidesWhenStopped = true
//            $0.stopAnimating()
        }.snp.makeConstraints { make in
            make.top.equalTo(confirmTableHeader.snp.bottom)
            make.left.right.equalTo(confirmTableHeader)
            make.height.equalTo(100)
        }
    }

    
    func setConfirmTable() {
        confirmTableHeader.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.left.right.equalToSuperview().inset(10.0)
        }
        
        confirmTable.addSubview(stackView)
        
        confirmTable.snp.makeConstraints { make in
            make.left.right.equalTo(confirmTableHeader)
            make.top.equalTo(confirmTableHeader.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        stackView.then {
            $0.axis = .vertical
            $0.spacing = 1.0
            $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
        }.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func setBinding() {
        let output = viewModel.transform(input: ConfirmVM.Input(id: ProfileDB.shared.get().id))
        
        output.transactions.subscribe(onNext: { transactions in
            self.loadingIndicatorView.stopAnimating()
            
            let transactions = transactions.sorted(by: { $0.Transaction.registeredDate > $1.Transaction.registeredDate })
            
            transactions.forEach { transaction in
                let data = transaction.Transaction
                
                let buyerInfo = self.buyerRepository.getBuyerInfo(id: Int(data.buyer!)!).asObservable()
                
                let supplierInfo = self.supplierRepository.getSupplierInfo(id: Int(data.supplier)!).asObservable()
                
                Observable.combineLatest(buyerInfo, supplierInfo)
                    .subscribe(onNext: { (buyer, supplier) in
                        let cell = ConfirmCell(
                            input: transaction.Transaction,
                            buyer: buyer.name)
                        self.stackView.addArrangedSubview(cell)
                        
                        let bank = supplier.bank_account
                        
                        cell.setConfirmButtomCommand {
                            self.present(ConfirmTransactionVC(input: ConfirmTransactionVC.Input(
                                transaction: data,
                                buyer: buyer.name,
                                bankAccount: "\(bank.bank.name) \(bank.number)")), animated: true)
                            
                        }
                    }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
    }
    
}
