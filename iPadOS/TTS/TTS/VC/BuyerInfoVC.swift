//
//  BuyerInfoVC.swift
//  TTS
//
//  Created by 안현주 on 2022/09/14.
//

import UIKit
import RxSwift

class BuyerInfoVC: UIViewController {
    private var disposeBag = DisposeBag()
    private var buyerRepository = BuyerRepository()
    private var supplierRepository = SupplierRepository()
    
    private var titleLabel = UILabel()
    
    private var balanceView: PriceView
    private var recSoldView: PriceView
    
    private var transactionHeader = TransactionHeader()
    private var transactionTable = UIScrollView()
    private var stackView = UIStackView()
    private var loadingIndicatorView = UIActivityIndicatorView(style: .large)
    
    private var viewModel = BuyerInfoVM()
    
    init() {
        self.balanceView = PriceView(input: PriceView.Input(
            icon: Const.Icon.balance,
            amount: 1000,
            unit: "REC",
            description: "총 구매 REC 개수",
            tintColor: Const.Color.semanticYellow2))
        
        self.recSoldView = PriceView(input: PriceView.Input(
            icon: Const.Icon.won,
            amount: 23423424,
            description: "총 REC 구매 대금",
            tintColor: Const.Color.semanticGreen2))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.Color.backgroundColor
        
        setView()
    }
    
    func setView() {
        [
            titleLabel,
            balanceView,
            recSoldView,
            transactionHeader,
            transactionTable,
            loadingIndicatorView
        ].forEach {
            self.view.addSubview($0)
        }
        setTitleLabel()
        setBalanceView()
        setRecSoldView()
        setTransactionTable()
        setLoadingIndicView()
        setBinding()
    }
    
    func setTitleLabel() {
        titleLabel.then {
            $0.text = "🧾 내 거래 내역"
            $0.textColor = Const.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        }.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30.0)
            make.left.equalToSuperview().inset(10.0)
        }
    }
    
    func setBalanceView() {
        balanceView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.height.equalTo(SupplierInfoVC.balanceViewHeight)
            make.width.equalTo(SupplierInfoVC.balanceViewWidth)
        }
    }
    
    func setRecSoldView() {
        recSoldView.snp.makeConstraints { make in
            make.left.equalTo(balanceView.snp.right).offset(10.0)
            make.top.equalTo(balanceView)
            make.height.equalTo(SupplierInfoVC.balanceViewHeight)
            make.width.equalTo(SupplierInfoVC.balanceViewWidth)
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
            make.top.equalTo(transactionHeader.snp.bottom)
            make.left.right.equalTo(transactionHeader)
            make.height.equalTo(100)
        }
    }
    
    func setTransactionTable() {
        transactionHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10.0)
            make.top.equalTo(balanceView.snp.bottom).offset(30.0)
        }
        
        transactionTable.addSubview(stackView)
        
        transactionTable.snp.makeConstraints { make in
            make.left.right.equalTo(transactionHeader)
            make.top.equalTo(transactionHeader.snp.bottom)
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
        let output = viewModel.transform(input: BuyerInfoVM.Input(id: ProfileDB.shared.get().id))
        
        output.transactions.subscribe(onNext: { transactions in
            self.loadingIndicatorView.stopAnimating()
            
            transactions.forEach { transaciton in
                let data = transaciton.Transaction
                
                let supplierInfo = self.supplierRepository.getSupplierInfo(id: Int(data.supplier)!).asObservable()
                
                if data.buyer != nil {
                    let buyerInfo = self.buyerRepository.getBuyerInfo(id: Int(data.buyer!)!).asObservable()
                    
                    Observable.combineLatest(buyerInfo,supplierInfo)
                        .subscribe(onNext: { (buyer, supplier) in
                            self.stackView.addArrangedSubview(
                                TransactionCell(
                                    input: data,
                                    supplier: supplier.name,
                                    buyer: buyer.name
                                ))
                        }).disposed(by: self.disposeBag)
                } else {
                    supplierInfo.subscribe(onNext: { supplier in
                        self.stackView.addArrangedSubview(
                            TransactionCell(
                                input: data,
                                supplier: "nil",
                                buyer: supplier.name
                            )
                        )
                    }).disposed(by: self.disposeBag)
                }
            }
        }).disposed(by: disposeBag)
    }
}
