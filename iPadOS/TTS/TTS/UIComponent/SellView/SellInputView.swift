//
//  SellInputView.swift
//  TTS
//
//  Created by Yujin Cha on 2022/09/04.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

extension SellInputView {
    static let horizontalInset: CGFloat = 20.0
    static let verticalOffset: CGFloat = 20.0
    static let buttonHeight: CGFloat = 75.0
}

class SellInputView: UIView {
    struct Input {
        var certificateId: String
        var recBalance: Int
    }
    
    var input: Input
    private var disposeBag = DisposeBag()
    private var repository = TransactionRepository()
    
    let numberFormatter = NumberFormatter().then {
        $0.numberStyle = .decimal
    }
    
    var stackView = UIStackView()
    
    var balanceView: PriceView
    
    lazy var label = UILabel()
    
    lazy var amountTextField = TextFieldWithDescription(
        input: TextFieldWithDescription.Input(
            title: "개수",
            initValue: "0",
            suffix: "개",
            isEnabled: true))
    
    lazy var priceTextField = TextFieldWithDescription(
        input: TextFieldWithDescription.Input(
            title: "개당",
            initValue: "0",
            suffix: "원",
            isEnabled: true))
    
    lazy var totalTextField = TextFieldWithDescription(
        input: TextFieldWithDescription.Input(
            title: "총",
            initValue: "0",
            suffix: "원",
            isEnabled: false))
    
    lazy var buyButton = UIButton()
    
    init(input: Input) {
        self.input = input
        balanceView = PriceView(input: PriceView.Input(
            icon: Const.Icon.balance,
            amount: input.recBalance,
            unit: "REC",
            description: "잔여 REC 공급량 수",
            tintColor: Const.Color.semanticYellow2))
        
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SellInputView {
    func setView() {
        backgroundColor = Const.Color.backgroundColor
        
        addSubview(stackView)
        addSubview(balanceView)
        addSubview(buyButton)
        
        setStackView()
        
        setBalanceView()
        setBuyButton()
    }
    
    func setStackView() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(priceTextField)
        stackView.addArrangedSubview(totalTextField)
        
        stackView.then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = SellInputView.verticalOffset
            $0.alignment = .center
        }.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview().inset(SellInputView.horizontalInset)
        }
        
        stackView.arrangedSubviews.forEach { textField in
            textField.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
        }
        
        setLabel()
        setAmountTextField()
        setPriceTextField()
    }
    
    func setLabel() {
        _ = label.then {
            $0.text = "매도 정보 입력"
            $0.textAlignment = .center
            $0.textColor = .white
            $0.backgroundColor = Const.Color.primary
            $0.font = UIFont.systemFont(ofSize: Const.Font.veryBig, weight: .bold)
        }
    }
    
    func setAmountTextField() {
        amountTextField.textField.keyboardType = .numberPad
        
        amountTextField.textField.rx.controlEvent([.editingChanged])
            .subscribe({ [weak self] _ in
                self?.setTextsByAmount()
            }).disposed(by: disposeBag)
    }
    
    func setPriceTextField() {
        priceTextField.textField.keyboardType = .numberPad
        
        priceTextField.textField.rx.controlEvent([.editingChanged])
            .subscribe({ [weak self] _ in
                self?.setTextsByPrice()
            }).disposed(by: disposeBag)
    }
    
    func setBalanceView() {
        balanceView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(30.0)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(SellInputView.horizontalInset)
            make.height.equalTo(SupplierInfoVC.balanceViewHeight * 1.25)
            make.width.equalToSuperview().multipliedBy(0.5).inset(SellInputView.horizontalInset)
        }
    }
    
    func setBuyButton() {
        buyButton.then {
            $0.setTitle("판매 등록", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: Const.Font.veryBig, weight: .bold)
            $0.backgroundColor = Const.Color.primary
            $0.tintColor = .white
            $0.setShadow()
        }.snp.makeConstraints { make in
            make.top.equalTo(balanceView)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(SellInputView.horizontalInset)
            make.height.equalTo(SupplierInfoVC.balanceViewHeight * 1.25)
            make.width.equalToSuperview().multipliedBy(0.5).inset(SellInputView.horizontalInset)
        }
    }
    
    func setButtonCommand(command: @escaping () -> Void) {
        buyButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                if self.totalTextField.textField.text == "0" { return }
                let quantity = Int(self.amountTextField.textField.text?.replacingOccurrences(of: ",", with: "") ?? "0")!
                let price = Int(self.priceTextField.textField.text?.replacingOccurrences(of: ",", with: "") ?? "0")!
                if quantity * price == 0 { return }
                
                self.repository.createTransaction(input: CreateTransactionModel(
                    target: self.input.certificateId,
                    price: price,
                    quantity: quantity,
                    supplier: ProfileDB.shared.get().id))
                .subscribe(onSuccess: { response in
                    if Array(200...299).contains(response.statusCode) {
                        command()
                    } else {
                        
                    }
                }).disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
    
}

extension SellInputView {
    func setTextsByAmount() {
        if let amountText = amountTextField.textField.text?.replacingOccurrences(of: ",", with: ""),
           let amount = Int(amountText),
           let convertedAmount = numberFormatter.string(from: NSNumber(value: amount)),
           let priceText = priceTextField.textField.text?.replacingOccurrences(of: ",", with: ""),
           let price = Int(priceText) {
            
            if amount > input.recBalance {
                guard let maxAmount = numberFormatter.string(from: NSNumber(value: input.recBalance)) else {
                    setDefault()
                    return
                }
                amountTextField.textField.text = "\(maxAmount)"
                totalTextField.textField.text = numberFormatter.string(from: NSNumber(value: input.recBalance * price))
                return
            }
            
            amountTextField.textField.text = "\(convertedAmount)"
            totalTextField.textField.text = numberFormatter.string(from: NSNumber(value: amount * price))
        } else {
            amountTextField.textField.text = "0"
            totalTextField.textField.text = "0"
        }
    }
    
    func setTextsByPrice() {
        if let amountText = amountTextField.textField.text?.replacingOccurrences(of: ",", with: ""),
           let amount = Int(amountText),
           let priceText = priceTextField.textField.text?.replacingOccurrences(of: ",", with: ""),
           let price = Int(priceText),
           let convertedPrice = numberFormatter.string(from: NSNumber(value: price)) {
            priceTextField.textField.text = "\(convertedPrice)"
            totalTextField.textField.text = numberFormatter.string(from: NSNumber(value: amount * price))
        } else {
            priceTextField.textField.text = "0"
            totalTextField.textField.text = "0"
        }
    }
    
    func setDefault() {
        amountTextField.textField.text = "0"
        priceTextField.textField.text = "0"
        totalTextField.textField.text = "0"
    }
    
}
