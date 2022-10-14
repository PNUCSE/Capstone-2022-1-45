//
//  RecHeader.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/08.
//

import UIKit

import Then
import SnapKit

extension RecHeader {
    static let fontSize: CGFloat = 23.0
}

class RecHeader: UIView {
    private var cell = UIStackView()
    
    private var recId = UILabel()
    private var expireDate = UILabel()
    private var quantity = UILabel()
    private var is_jeju = UILabel()
    private var sellButton = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .lightGray.withAlphaComponent(0.15)
        self.layer.cornerRadius = 8.0
        setView()
    }
    
    func setView() {
        self.addSubview(cell)
        setCell()
        setRecId()
        setExpireDate()
        setQuantity()
        setIsJeju()
        setSellButton()
    }
    
    func setCell() {
        [recId, expireDate, quantity, is_jeju, sellButton].forEach {
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
    
    func setRecId() {
        recId.then {
            $0.text = "인증서 ID"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: RecHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.top.bottom.equalToSuperview().inset(12.0)
        }
    }
    
    func setExpireDate() {
        expireDate.then {
            $0.text = "만료 일자"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: RecHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    func setQuantity() {
        quantity.then {
            $0.text = "수량"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: RecHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    func setIsJeju() {
        is_jeju.then {
            $0.text = "발전 지역"
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: RecHeader.fontSize)
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    func setSellButton() {
        sellButton.then {
            $0.text = ""
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: RecHeader.fontSize)
        }.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
