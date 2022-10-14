//
//  ProfileCard.swift
//  TTS
//
//  Created by Yujin Cha on 2022/09/05.
//

import UIKit

extension ProfileCard {
    static let imageSize = 150.0
    static let horizontalInset: CGFloat = 20.0
    static let verticalInset: CGFloat = 50.0
    static let verticalOffset: CGFloat = 20.0
    
    static let labelVerticalOffset: CGFloat = 10.0
    static let sampleInput = Input(name: "사용자",
                                   role: "발전사업자",
                                   company: "부산 풍력 발전소",
                                   email: "asdgsed35es4sd4gr5eyhsegfd3hgre15")
}

class ProfileCard: UIView {
    struct Input {
        var name: String
        var role: String
        var company: String
        var email: String
    }
    
    var input: Input
    
    lazy var profileImageView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var roleLabel = UILabel()
    lazy var companyLabel = UILabel()
    lazy var emailLabel = UILabel()
    
    init(input: Input) {
        self.input = input
        
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileCard {
    func setView() {
        backgroundColor = .white
        setShadow()
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(roleLabel)
        addSubview(companyLabel)
        addSubview(emailLabel)
        
        setProfileImageView()
        setNameLabel()
        setRoleLabel()
        setCompanyLabel()
        setWalletIDLabel()
    }
    
    func setProfileImageView() {
        profileImageView.then {
            $0.image = UIImage(systemName: "person.circle.fill")
            $0.tintColor = Const.Color.primary
        }.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(ProfileCard.verticalInset)
            make.width.height.equalTo(ProfileCard.imageSize)
        }
    }
    
    func setNameLabel() {
        nameLabel.then {
            $0.text = "\(input.name) 님"
            $0.font = UIFont.systemFont(ofSize: Const.Font.veryBig, weight: .bold)
        }.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(ProfileCard.verticalOffset)
        }
    }
    
    func setRoleLabel() {
        roleLabel.then {
            $0.text = input.role
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: Const.Font.big, weight: .semibold)
            $0.textAlignment = .center
            $0.backgroundColor = Const.Color.primary.withAlphaComponent(0.2)
            $0.layer.cornerRadius = 5.0
            $0.layer.masksToBounds = true
        }.snp.makeConstraints { make in
            make.width.equalTo(roleLabel.intrinsicContentSize.width + 20)
            make.height.equalTo(roleLabel.intrinsicContentSize.height + 10)
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(ProfileCard.labelVerticalOffset)
        }
    }
    
    func setCompanyLabel() {
        companyLabel.then {
            $0.text = "\(input.company) 소속"
            $0.font = UIFont.systemFont(ofSize: Const.Font.veryBig)
        }.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(roleLabel.snp.bottom).offset(ProfileCard.labelVerticalOffset)
        }
    }
    
    func setWalletIDLabel() {
        emailLabel.then {
            $0.text = input.email
            $0.textColor = .gray
            $0.font = UIFont.systemFont(ofSize: Const.Font.big, weight: .light)
        }.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(companyLabel.snp.bottom).offset(ProfileCard.labelVerticalOffset)
            make.bottom.equalToSuperview().inset(ProfileCard.verticalInset)
        }
    }
    
}
