//
//  RecBuyVC.swift
//  TTS
//
//  Created by 안현주 on 2022/09/13.
//

import UIKit
import Then
import SnapKit
import RxSwift

import RxSwift

class RecBuyVC: UIViewController {
    private let txRepository = TransactionRepository()
    private let supplierRepository = SupplierRepository()
    private let disposeBag = DisposeBag()
    
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    private var averageView: PriceView
    private var highPriceView: PriceView
    private var lowPriceView: PriceView
    
    private var transactionDate: ConfirmTransactionCell
    private var supplierInfo: ConfirmTransactionCell
    private var pricePerRec: ConfirmTransactionCell
    private var transactionVolume: ConfirmTransactionCell
    private var totalPrice: ConfirmTransactionCell
    private var bankAccount: ConfirmTransactionCell
    
    private var priceStackView = UIStackView()
    private var tranInfoStackView = UIStackView()
    private var buyButton = UIButton()
    
    private var input: TransactionModel.InnerModel

    init(input: TransactionModel.InnerModel) {
        self.input = input
        self.averageView = PriceView(input: PriceView.Input(
            icon: Const.Icon.won,
            amount: 10000,
            description: "평균가",
            tintColor: Const.Color.semanticGreen2))
        
        self.highPriceView = PriceView(input: PriceView.Input(
            icon: Const.Icon.upArrow,
            amount: 10000,
            description: "최고가",
            tintColor: Const.Color.semanticRed2))
        
        self.lowPriceView = PriceView(input: PriceView.Input(
            icon: Const.Icon.downArrow,
            amount: 10000,
            description: "최저가",
            tintColor: Const.Color.semanticBlue2))
        
        transactionDate = ConfirmTransactionCell(input: ConfirmTransactionCell.Input(
            title: "거래 등록 일시",
            content: DateTimeConverter.fromIntToString(input: input.registeredDate)))
        
        supplierInfo = ConfirmTransactionCell(input: ConfirmTransactionCell.Input(title: "판매자", content: "한국 전력"))
        
        pricePerRec = ConfirmTransactionCell(input: ConfirmTransactionCell.Input(title: "인증서 개당 가격", content: "\(input.price.getFormattedString()) 원"))
        
        transactionVolume = ConfirmTransactionCell(input: ConfirmTransactionCell.Input(title: "거래 수량", content: "\(input.quantity.getFormattedString()) 개"))
        
        totalPrice = ConfirmTransactionCell(input: ConfirmTransactionCell.Input(title: "총 거래 대금", content: "\((input.price * input.quantity).getFormattedString()) 원"))
        
        bankAccount = ConfirmTransactionCell(input: ConfirmTransactionCell.Input(title: "입금 계좌", content: "부산은행 112-3723-4838-47"))
        
        super.init(nibName: nil, bundle: nil)
        
        updatePriceViews()
        updateInfoViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.Color.backgroundColor
        
        setView()
    }
    
    func setView() {
        [
            titleLabel,
            priceStackView,
            subTitleLabel,
            tranInfoStackView,
            buyButton
        ].forEach {
            self.view.addSubview($0)
        }
        setTitle()
        setPriceStackView()
        setSubTitle()
        setTranInfoStackView()
        setBuyButton()
    }
    
    func setTitle() {
        titleLabel.then {
            $0.text = "인증서 매수"
            $0.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
            $0.textColor = Const.Color.textColor
        }.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40.0)
            make.left.equalToSuperview().inset(10.0)
        }
    }
    
    func setPriceStackView() {
        [averageView, highPriceView, lowPriceView].forEach {
            priceStackView.addArrangedSubview($0)
        }
        
        priceStackView.then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10.0
        }.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.left.right.equalToSuperview().inset(10.0)
        }
    }
    
    func setSubTitle() {
        subTitleLabel.then {
            $0.text = "구매 정보"
            $0.font = UIFont.systemFont(ofSize: 35.0, weight: .semibold)
            $0.textColor = Const.Color.textColor
        }.snp.makeConstraints { make in
            make.top.equalTo(priceStackView.snp.bottom).offset(40.0)
            make.left.equalToSuperview().inset(20.0)
        }
    }
    
    func setTranInfoStackView() {
        [transactionDate, supplierInfo, pricePerRec, transactionVolume, totalPrice, bankAccount].forEach {
            tranInfoStackView.addArrangedSubview($0)
        }
        
        tranInfoStackView.then {
            $0.axis = .vertical
            $0.spacing = 1.0
        }.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10.0)
            make.left.right.equalToSuperview().inset(10.0)
        }
    }
    
    func setBuyButton() {
        buyButton.then {
            $0.setTitle("구매하기", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 27.0, weight: .bold)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = Const.Color.primary
            $0.layer.cornerRadius = 5.0
        }.snp.makeConstraints { make in
            make.top.equalTo(tranInfoStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20.0)
            make.height.equalTo(55.0)
        }
        setButtonCommand()
    }
    
    func setButtonCommand() {
        buyButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.txRepository.executeTransaction(
                    input: ExecuteTransactionModel(id: self.input.id,
                                                   buyer: ProfileDB.shared.get().id))
                .subscribe(onSuccess: { response in
                    if Array(200...299).contains(response.statusCode) {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        
                    }
                }).disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
    
    func updatePriceViews() {
        txRepository.getPriceAvgMaxMin()
            .subscribe { arr in
                self.averageView.update(value: arr[0])
                self.highPriceView.update(value: arr[1])
                self.lowPriceView.update(value: arr[2])
            } onFailure: { err in
                print(err)
            }.disposed(by: disposeBag)
    }
    
    func updateInfoViews() {
        supplierRepository.getSupplierInfo(id: Int(input.supplier)!)
            .asObservable()
            .subscribe { supplierModel in
                if let supplierModel = supplierModel.element {
                    self.supplierInfo.update(content: supplierModel.name)
                    self.bankAccount.update(content: supplierModel.bank_account.getString())
                }
            }.disposed(by: disposeBag)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
