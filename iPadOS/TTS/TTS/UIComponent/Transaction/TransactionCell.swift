//
//  TransactionCell.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/04.
//

import UIKit

import Then
import SnapKit

extension TransactionCell {
    static let fontSize: CGFloat = 21.0
}

class TransactionCell: UIView {
    private var cell = UIStackView()
    
    private var timeStamp = UILabel()
    private var sender = UILabel()
    private var receiver = UILabel()
    private var pricePerREC = UILabel()
    private var quantity = UILabel()
    private var status = UIView()
    
    private var input: TransactionModel.InnerModel
    private var supplier: String
    private var buyer: String
    
    init(input: TransactionModel.InnerModel, supplier: String, buyer: String) {
        self.input = input
        self.supplier = supplier
        self.buyer = buyer
        
        super.init(frame: .zero)
        self.backgroundColor = .white
        setView()
    }
    
    func setView() {
        self.addSubview(cell)
        setCell()
        setTimeStamp()
        setSender()
        setReceiver()
        setPricePerREC()
        setQuantity()
        setStatus()
    }
    
    func setCell() {
        [timeStamp, sender, receiver, pricePerREC, quantity, status].forEach {
            cell.addArrangedSubview($0)
        }
        
        cell.then {
            $0.axis = .horizontal
            $0.alignment = .firstBaseline
        }.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10.0)
        }
    }
    
    func setTimeStamp() {
        timeStamp.then {
            if let time = input.executedDate {
                $0.text = "\(DateTimeConverter.fromIntToString(input: time))"
            } else {
                $0.text = "-"
            }
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.325)
            make.top.bottom.equalToSuperview().inset(12.0)
        }
    }
    
    func setSender() {
        sender.then {
            $0.text = self.supplier
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.125)
        }
    }
    
    func setReceiver() {
        receiver.then {
            if self.buyer != "nil" {
                $0.text = self.buyer
            } else {
                $0.text = "."
            }
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.125)
        }
    }
    
    func setPricePerREC() {
        pricePerREC.then {
            $0.text = "\(input.price)원"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    func setQuantity() {
        quantity.then {
            $0.text = "\(input.quantity)개"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionCell.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    func setStatus() {
        let statusLabel = BasePaddingLabel()
        status.snp.makeConstraints { make in
            make.height.equalTo(quantity)
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
            $0.font = UIFont.systemFont(ofSize: TransactionCell.fontSize, weight: .bold)
            $0.backgroundColor = backgroundColor
            $0.layer.cornerRadius = 5.0
            $0.layer.masksToBounds = true

        }.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
