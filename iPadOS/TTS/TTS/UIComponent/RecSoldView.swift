//
//  RecSoldView.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/04.
//

//
//  BalanceView.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/04.
//

import UIKit

import Then
import SnapKit

class RecSoldView: UIView {
    private var iconView = UIImageView()
    private var balanceLabel = UILabel()
    private var balanceDescription = UILabel()
    
    init() {
        super.init(frame: .zero)
        setView()
    }
    
    func setView() {
        [iconView, balanceLabel, balanceDescription].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .white
        setShadow()
        setIconView()
        setBalanceLabel()
        setBalanceDescription()
    }
    
    func setIconView() {
        iconView.then {
            $0.image = UIImage(systemName: "wonsign.circle.fill")
            $0.tintColor = Const.Color.primary
            $0.contentMode = .scaleAspectFill
        }.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10.0)
            make.height.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func setBalanceLabel() {
        balanceLabel.then {
            $0.text = "23,432,684 원"
            $0.font = UIFont.systemFont(ofSize: 22.0)
            $0.textColor = .gray
        }.snp.makeConstraints { make in
            make.left.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(12.0)
        }
    }
    
    func setBalanceDescription() {
        balanceDescription.then {
            $0.text = "총 REC 판매 금액"
            $0.font = UIFont.systemFont(ofSize: 18.0)
            $0.textColor = .lightGray
        }.snp.makeConstraints { make in
            make.left.equalTo(balanceLabel)
            make.top.equalTo(balanceLabel.snp.bottom).offset(7.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

