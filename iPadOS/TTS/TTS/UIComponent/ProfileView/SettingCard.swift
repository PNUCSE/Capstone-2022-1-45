//
//  SettingCard.swift
//  TTS
//
//  Created by Yujin Cha on 2022/09/05.
//

import UIKit
import Then
import SnapKit
import RxSwift

extension SettingCard {
    static let imageSize = 30.0
    static let horizontalInset: CGFloat = 20.0
    static let verticalOffset: CGFloat = 30.0
}

class SettingCard: UIView {
    
    struct Input {
        var title: String
        var image: UIImage?
    }
    
    var input: Input
    
    lazy var titleLabel = UILabel()
    lazy var imageView = UIImageView()
    
    var action: (() -> ())?
    var disposeBag = DisposeBag()
    
    init(input: Input) {
        self.input = input
        
        super.init(frame: .zero)
        
        setView()
        
        rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext:  { [weak self] _ in
                (self?.action ?? {})()
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingCard {
    func setView() {
        backgroundColor = .white
        setShadow()
        
        addSubview(titleLabel)
        addSubview(imageView)
        
        setTitleLabel()
        setImageView()
    }
    
    func setTitleLabel() {
        titleLabel.then {
            $0.text = input.title
            $0.font = UIFont.systemFont(ofSize: Const.Font.big)
        }.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(SettingCard.verticalOffset)
            make.left.equalToSuperview().inset(SettingCard.horizontalInset)
        }
    }
    
    func setImageView() {
        imageView.then {
            $0.image = input.image
            $0.tintColor = .lightGray
        }.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(SettingCard.horizontalInset)
            make.width.height.equalTo(SettingCard.imageSize)
        }
    }
    
}
