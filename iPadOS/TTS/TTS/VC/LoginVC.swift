//
//  LoginVC.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxGesture

extension LoginVC {
    static let componentWidthRatio: CGFloat = 0.5
    static let offset: CGFloat = 15.0
    static let componentHeight: CGFloat = 63.0
}

class LoginVC: UIViewController {
    private var disposeBag = DisposeBag()
    
    private var logoView = UIView()
    private var logoImage = UIImageView()
    private var logoLabel = UILabel()
    private var emailField = UITextField()
    private var passwordField = UITextField()
    private var loginButton = UIButton()
    
    private var viewModel = LoginVM()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        [logoView, emailField, passwordField, loginButton].forEach {
            self.view.addSubview($0)
        }
        setLogoView()
        setEmailField()
        setPasswordField()
        setLoginButton()
        setBinding()
    }
    
    func setLogoView() {
        [logoImage, logoLabel].forEach {
            logoView.addSubview($0)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(300.0)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        logoImage.then {
            $0.image = Const.Icon.volt
            $0.tintColor = Const.Color.primary
        }.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(125.0)
            make.height.width.equalTo(100.0)
            make.centerY.equalToSuperview()
        }
        
        logoLabel.then {
            $0.text = "신재생 에너지\n거래 플랫폼"
            $0.textColor = Const.Color.primary
            $0.font = UIFont.systemFont(ofSize: 50.0, weight: .bold)
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }.snp.makeConstraints { make in
            make.left.equalTo(logoImage.snp.right).offset(10.0)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func setEmailField() {
        emailField.then {
            $0.placeholder = "이메일"
            $0.leftViewMode = .always
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            $0.keyboardType = .emailAddress
            $0.textContentType = .emailAddress
            $0.autocapitalizationType = .none
            $0.layer.cornerRadius = 8
            $0.font = UIFont.systemFont(ofSize: 28.0, weight: .light)
            $0.backgroundColor = .systemGroupedBackground
        }.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(40.0)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(LoginVC.componentWidthRatio)
            make.height.equalTo(LoginVC.componentHeight)
        }
    }
    
    func setPasswordField() {
        passwordField.then {
            $0.placeholder = "비밀번호"
            $0.leftViewMode = .always
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            $0.autocapitalizationType = .none
            $0.textContentType = .password
            $0.isSecureTextEntry = true
            $0.layer.cornerRadius = 8
            $0.font = UIFont.systemFont(ofSize: 28.0, weight: .light)
            $0.backgroundColor = .systemGroupedBackground
        }.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(emailField)
            make.top.equalTo(emailField.snp.bottom).offset(LoginVC.offset)
            make.height.equalTo(LoginVC.componentHeight)
        }
    }
    
    func setLoginButton() {
        loginButton.then {
            $0.setTitle("로그인", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 30.0, weight: .medium)
            $0.backgroundColor = Const.Color.primary
            $0.tintColor = .white
            $0.layer.cornerRadius = 8.0
        }.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordField.snp.bottom).offset(LoginVC.offset)
            make.height.width.equalTo(emailField)
        }
    }
    
    func setBinding() {
        let output = viewModel.transform(
            input: LoginVM.Input(
                emailField: emailField.rx.text.asObservable(),
                passwordField: passwordField.rx.text.asObservable(),
                isTapped: loginButton.rx.tapGesture().when(.recognized).asObservable())
        )
        
        output.isValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isLoginSuccess
            .subscribe(onNext: { result in
                if result {
                    let nextVC = SplitVC()
                    nextVC.modalTransitionStyle = .crossDissolve
                    nextVC.modalPresentationStyle = .fullScreen
                    self.present(nextVC, animated: true)
                } else {
                    let alert = UIAlertController(title: "로그인 실패", message: "로그인에 실패하였습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
