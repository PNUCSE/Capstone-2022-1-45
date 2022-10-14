//
//  RecCellVC.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/11.
//

import UIKit

import Charts
import Then
import SnapKit
import RxSwift
import RxGesture

class RecSellVC: UIViewController {
    private var repository = TransactionRepository()
    private var disposeBag = DisposeBag()
    
    private var titleLabel = UILabel()
    private var averageView: PriceView
    private var highPriceView: PriceView
    private var lowPriceView: PriceView
    private var sellInputView: SellInputView
    private var stackView = UIStackView()

    private var input: RecModel.InnerModel
    init(input: RecModel.InnerModel) {
        self.input = input
        
        self.averageView = PriceView(input: PriceView.Input(
            icon: Const.Icon.won,
            amount: 10000,
            description: "평균가",
            tintColor: Const.Color.semanticGreen2))
        
        self.highPriceView = PriceView(input: PriceView.Input(
            icon: Const.Icon.upArrow,
            amount: 10000,
            description: "최고가",
            tintColor: Const.Color.semanticRed2))
        
        self.lowPriceView = PriceView(input: PriceView.Input(
            icon: Const.Icon.downArrow,
            amount: 10000,
            description: "최저가",
            tintColor: Const.Color.semanticBlue2))
        
        self.sellInputView = SellInputView(input: SellInputView.Input(
            certificateId: input.id,
            recBalance: input.quantity))
        
        super.init(nibName: nil, bundle: nil)
        
        updatePriceViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.Color.backgroundColor
        [titleLabel, stackView, sellInputView].forEach {
            self.view.addSubview($0)
        }
        
        setView()
    }
    
    func setView() {
        setTitle()
        setStackView()
        setSellInputView()
    }
    
    func setTitle() {
        titleLabel.then {
            $0.text = "인증서 매도"
            $0.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
            $0.textColor = Const.Color.textColor
        }.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40.0)
            make.left.equalToSuperview().inset(10.0)
        }
    }
    
    func setStackView() {
        [averageView, highPriceView, lowPriceView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10.0
        }.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.left.right.equalToSuperview().inset(10.0)
        }
    }
    
    func setSellInputView() {
        sellInputView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(30.0)
            make.left.right.equalToSuperview()
        }
        
        sellInputView.setButtonCommand {
            self.dismiss(animated: true)
        }
    }
    
    func updatePriceViews() {
        repository.getPriceAvgMaxMin()
            .subscribe { arr in
                self.averageView.update(value: arr[0])
                self.highPriceView.update(value: arr[1])
                self.lowPriceView.update(value: arr[2])
            } onFailure: { err in
                print(err)
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
