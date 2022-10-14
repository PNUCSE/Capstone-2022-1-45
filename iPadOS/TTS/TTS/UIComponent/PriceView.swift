//
//  PriceView.swift
//  TTS
//
//  Created by Yujin Cha on 2022/09/04.
//

import UIKit

import Then
import SnapKit

class PriceView: UIView {
    
    struct Input {
        var icon: UIImage?
        var amount: Int
        var unit: String = "원"
        var description: String
        var tintColor: UIColor = Const.Color.primary
    }
    
    var input: Input
    
    private var iconView = UIImageView()
    private var label = UILabel()
    private var descriptionLabel = UILabel()
    
    let numberFormatter = NumberFormatter().then {
        $0.numberStyle = .decimal
    }
    
    init(input: Input) {
        self.input = input
        
        super.init(frame: .zero)
        setView()
    }
    
    func update(value: Int) {
        label.text = "\(numberFormatter.string(from: NSNumber(value: value))!) \(input.unit)"
    }
    
    func setView() {
        [iconView, label, descriptionLabel].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .white
        setShadow()
        
        setIconView()
        setLabel()
        setDescription()
    }
    
    func setIconView() {
        iconView.then {
            $0.image = input.icon
            $0.tintColor = input.tintColor
            $0.contentMode = .scaleAspectFill
        }.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.centerY.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func setLabel() {
        label.then {
            $0.text = "\(numberFormatter.string(from: NSNumber(value: input.amount))!) \(input.unit)"
            $0.font = UIFont.systemFont(ofSize: 25.0)
            $0.textColor = .gray
        }.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(20.0)
            make.centerY.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    func setDescription() {
        descriptionLabel.then {
            $0.text = input.description
            $0.font = UIFont.systemFont(ofSize: 18.0)
            $0.textColor = .lightGray
        }.snp.makeConstraints { make in
            make.left.equalTo(label)
            make.top.equalTo(label.snp.bottom).offset(7.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
