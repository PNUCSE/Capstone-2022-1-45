//
//  TransactionHeader.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/04.
//

import UIKit

import Then
import SnapKit

extension TransactionHeader {
    static let fontSize: CGFloat = 23.0
}

class TransactionHeader: UIView {
    private var cell = UIStackView()
    
    private var timeStamp = UILabel()
    private var sender = UILabel()
    private var receiver = UILabel()
    private var pricePerREC = UILabel()
    private var quantity = UILabel()
    private var status = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .lightGray.withAlphaComponent(0.15)
        self.layer.cornerRadius = 8.0
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
            $0.alignment = .leading
        }.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10.0)
        }
    }
    
    func setTimeStamp() {
        timeStamp.then {
            $0.text = "거래 일시"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.325)
            make.top.bottom.equalToSuperview().inset(12.0)
        }
    }
    
    func setSender() {
        sender.then {
            $0.text = "공급자"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.125)
        }
    }
    
    func setReceiver() {
        receiver.then {
            $0.text = "구매자"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.125)
        }
    }
    
    func setPricePerREC() {
        pricePerREC.then {
            $0.text = "개당 금액"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    func setQuantity() {
        quantity.then {
            $0.text = "거래 수량"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    func setStatus() {
        status.then {
            $0.text = "거래 상태"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: TransactionHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.175)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

