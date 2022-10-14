//
//  ConfirmTransactionCell.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/11.
//

import UIKit

import Then
import SnapKit

class ConfirmTransactionCell: UIView {
    
    struct Input {
        var title: String
        var content: String
    }
    
    private var input: Input
    private var titleLabel = UILabel()
    private var contentLabel = UILabel()
    
    init(input: Input) {
        self.input = input
        super.init(frame: .zero)
        setView()
    }
    
    func update(content: String) {
        contentLabel.text = content
    }
    
    func setView() {
        [titleLabel, contentLabel].forEach {
            self.addSubview($0)
        }
        setTitle()
        setContent()
    }
    
    func setTitle() {
        titleLabel.then {
            $0.text = input.title
            $0.textColor = Const.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 20.0, weight: .light)
        }.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10.0)
        }
    }
    
    func setContent() {
        contentLabel.then {
            $0.text = input.content
            $0.textColor = Const.Color.textColor
            $0.font = UIFont.systemFont(ofSize: 27.0, weight: .medium)
        }.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(10.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
