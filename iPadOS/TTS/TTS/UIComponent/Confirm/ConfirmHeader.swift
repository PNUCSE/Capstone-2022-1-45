//
//  ConfirmHeader.swift
//  TTS
//
//  Created by 안현주 on 2022/09/08.
//

import UIKit
import Then
import SnapKit

extension ConfirmHeader {
    static let fontSize: CGFloat = 23.0
}

class ConfirmHeader: UIView {
    private var cell = UIStackView()
    
    private var timeStamp = UILabel()
    private var receiver = UILabel()
    private var pricePerREC = UILabel()
    private var quantity = UILabel()
    private var confirm = UILabel()
    
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
        setReceiver()
        setPricePerREC()
        setQuantity()
        setConfirm()
    }
    
    func setCell() {
        [timeStamp, receiver, pricePerREC, quantity, confirm].forEach {
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
            $0.text = "요청 일시"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.325)
            make.top.bottom.equalToSuperview().inset(12.0)
        }
    }
        
    func setReceiver() {
        receiver.then {
            if ProfileDB.shared.get().is_supplier {
                $0.text = "구매자"
            } else {
                $0.text = "판매자"
            }
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func setPricePerREC() {
        pricePerREC.then {
            $0.text = "개당 금액"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    func setQuantity() {
        quantity.then {
            $0.text = "거래 수량"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    func setConfirm() {
        confirm.then {
            $0.text = "거래 승인"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: ConfirmHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.175)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
