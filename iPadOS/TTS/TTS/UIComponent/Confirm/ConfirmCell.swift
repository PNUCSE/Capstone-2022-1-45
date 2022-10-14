//
//  ConfirmCell.swift
//  TTS
//
//  Created by 안현주 on 2022/09/08.
//

import UIKit

import RxSwift
import RxGesture
import Then
import SnapKit

extension ConfirmCell {
    static let fontSize: CGFloat = 21.0
}

class ConfirmCell: UIView {
    private var disposeBag = DisposeBag()
    
    private var cell = UIStackView()
    
    private var timeStamp = UILabel()
    private var receiver = UILabel()
    private var pricePerREC = UILabel()
    private var quantity = UILabel()
    private var status = UIView()
    private var confirm = UIView()
    private var confirmButton = UIButton()
    
    private var input: TransactionModel.InnerModel
    private var buyer: String
    
    init(input: TransactionModel.InnerModel, buyer: String) {
        self.input = input
        self.buyer = buyer
        
        super.init(frame: .zero)
        self.backgroundColor = .white
        setView()
    }
    
    func setView() {
        self.addSubview(cell)
        setCell()
        setTimeStamp()
        setReceiver()
        setPricePerREC()
        setQuantity()
    }
    
    func setCell() {
        cell.then {
            $0.axis = .horizontal
            $0.alignment = .firstBaseline
        }.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10.0)
        }
        
        [
            timeStamp,
            receiver,
            pricePerREC,
            quantity
        ].forEach {
            cell.addArrangedSubview($0)
        }
        
        if ProfileDB.shared.get().is_supplier {
            cell.addArrangedSubview(confirm)
            setConfirm()
        } else {
            cell.addArrangedSubview(status)
            setStatus()
        }
    }
    
    func setTimeStamp() {
        timeStamp.then {
            $0.text = "\(DateTimeConverter.fromIntToString(input: input.registeredDate))"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.325)
            make.top.bottom.equalToSuperview().inset(12.0)
        }
    }
        
    func setReceiver() {
        receiver.then {
            $0.text = buyer
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.top.bottom.equalTo(timeStamp)
        }
    }
    
    func setPricePerREC() {
        pricePerREC.then {
            $0.text = "\(input.price)원"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
            make.top.bottom.equalTo(timeStamp)
        }
    }
    
    func setQuantity() {
        quantity.then {
            $0.text = "\(input.quantity)개"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
            make.top.bottom.equalTo(timeStamp)
        }
    }
    
    func setStatus() {
        let statusLabel = BasePaddingLabel()
        status.snp.makeConstraints { make in
            make.top.bottom.equalTo(timeStamp)
            make.width.equalToSuperview().multipliedBy(0.175)
        }
        
        status.addSubview(statusLabel)
        
        var text = "거래 대금 확인 중"
        var textColor = Const.Color.semanticYellow2
        var backgroundColor = Const.Color.semanticYellow1
        if input.buyer == nil {
            text = "미체결"
            textColor = Const.Color.semanticRed2
            backgroundColor = Const.Color.semanticRed1
        } else if input.is_confirmed {
            text = "거래 완료"
            textColor = Const.Color.semanticGreen2
            backgroundColor = Const.Color.semanticGreen1
        }
        
        statusLabel.then {
            $0.text = text
            $0.textColor = textColor
            $0.font = UIFont.systemFont(ofSize: ConfirmCell.fontSize, weight: .bold)
            $0.backgroundColor = backgroundColor
            $0.layer.cornerRadius = 5.0
            $0.layer.masksToBounds = true

        }.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setConfirm() {
        confirm.snp.makeConstraints { make in
            make.height.equalTo(quantity)
            make.width.equalToSuperview().multipliedBy(0.175)
        }
        confirm.addSubview(confirmButton)
        
        confirmButton.then {
            $0.setTitle("승인하기", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: ConfirmCell.fontSize, weight: .bold)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = Const.Color.primary
            $0.layer.cornerRadius = 5.0
        }.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    func setConfirmButtomCommand(command: @escaping (() -> Void)) {
        confirmButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                command()
            }).disposed(by: disposeBag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

