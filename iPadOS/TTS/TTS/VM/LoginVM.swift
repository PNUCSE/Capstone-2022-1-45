//
//  LoginViewModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import Moya
import RxSwift
import RxCocoa
import RxRelay

struct LoginVM: BasicVM {
    internal var disposeBag = DisposeBag()
    private var repository = LoginRepository()
    
    struct Input {
        let emailField: Observable<String?>
        let passwordField: Observable<String?>
        let isTapped: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let isLoginSuccess: Observable<Bool>
    }
    
    let emailRelay = BehaviorRelay<String?>(value: "")
    let passwordRelay = BehaviorRelay<String?>(value: "")
    
    let isLoginSuccess = PublishRelay<Bool>()
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailRelay, passwordRelay) { email, password in
            guard let email = email, let password = password else { return false }
            return email != "" && password != ""
        }
    }
    
    func transform(input: Input) -> Output {
        input.emailField
            .subscribe { email in
                self.emailRelay.accept(email)
            }.disposed(by: disposeBag)
        
        input.passwordField
            .subscribe { password in
                self.passwordRelay.accept(password)
            }.disposed(by: disposeBag)
        
        input.isTapped
            .subscribe { _ in
                self.login()
            }.disposed(by: disposeBag)
        
        return Output(
            isValid: isValid,
            isLoginSuccess: isLoginSuccess.asObservable()
        )
    }
    
    func login() {
        repository.login(input: LoginModel(email: self.emailRelay.value!, password: self.passwordRelay.value!))
            .flatMap { token -> Single<UserModel> in
                TokenDB.shared.save(data: token)
                return repository.verifyUser()
            }.subscribe(onSuccess: { result in
                ProfileDB.shared.save(data: result)
                self.isLoginSuccess.accept(true)
            }, onFailure: { result in
                self.isLoginSuccess.accept(false)
            }).disposed(by: disposeBag)
    }
}


