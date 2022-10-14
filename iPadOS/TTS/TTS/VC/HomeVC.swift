//
//  HomeViewController.swift
//  TTS
//
//  Created by 안현주 on 2022/08/30.
//

import UIKit
import Charts
import Then
import SnapKit
import RxSwift

class HomeVC: UIViewController {
    
    var xData: [String]!
    var yData: [Double]!
    let chartLabelSize = CGFloat(15)

    private var viewModel = HomeVM()
    private var disposeBag = DisposeBag()
    private var repository = TransactionRepository()
    private var buyerRepository = BuyerRepository()
    private var supplierRepository = SupplierRepository()
    
    private var titleLabel = UILabel()
    private var hourlyChartButton = UIButton()
    private var dailyChartButton = UIButton()
    private var monthlyChartButton = UIButton()
    
    private var viewChart = UIView()
    private var lineChartView = ChartView()
    private var allTransactionHeader = TransactionHeader()
    private var allTransactionTable = UIScrollView()
    private var stackView = UIStackView()
    private var loadingIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.Color.backgroundColor
        
        setView()
    }
    
    func setView() {
        [titleLabel,
         viewChart,
         allTransactionHeader,
         loadingIndicatorView,
         allTransactionTable
        ].forEach {
            view.addSubview($0)
        }
        setTitle()
        setChartView()
        setAllTransactionsTable()
        setLoadingIndicView()
        setBinding()
        
        repository.getExecutedTransaction()
            .subscribe(onSuccess: { transactions in
                let chartData = ChartConverter.getDaily(input: transactions)
                self.setChartData(dataPoints: chartData.xData, values: chartData.yData, limit: chartData.average)
            }).disposed(by: disposeBag)
    }
    
    func setTitle() {
        titleLabel.then {
            $0.text = "🏠 홈 화면"
            $0.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
            $0.textColor = Const.Color.textColor
        }.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30.0)
            make.left.equalToSuperview().inset(10.0)
        }
    }
    
    func setChartView() {
        [
            lineChartView,
            hourlyChartButton,
            dailyChartButton,
            monthlyChartButton
        ].forEach { view in
            viewChart.addSubview(view)
        }
        
        viewChart.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.height.equalTo(350)
            make.left.right.equalToSuperview().inset(10.0)
        }
        setButtons()
        setChart()
    }
    
    func setLoadingIndicView() {
        loadingIndicatorView.then {
            $0.center = self.view.center
            $0.color = Const.Color.primary
            $0.startAnimating()
            $0.hidesWhenStopped = true
//            $0.stopAnimating()
        }.snp.makeConstraints { make in
            make.top.equalTo(allTransactionHeader.snp.bottom)
            make.left.right.equalTo(allTransactionHeader)
            make.height.equalTo(100)
        }
    }
    
    func setButtons() {
        hourlyChartButton.then {
            $0.setTitle("Hour", for: .normal)
            $0.backgroundColor = Const.Color.primary
            $0.tintColor = .white
            $0.layer.cornerRadius = 5.0
        }.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }

        dailyChartButton.then {
            $0.setTitle("Day", for: .normal)
            $0.backgroundColor = Const.Color.primary
            $0.tintColor = .white
            $0.layer.cornerRadius = 5.0
        }.snp.makeConstraints { make in
            make.top.width.height.equalTo(hourlyChartButton)
            make.leading.equalTo(hourlyChartButton.snp.trailing).offset(5)
        }
        
        monthlyChartButton.then {
            $0.setTitle("Month", for: .normal)
            $0.backgroundColor = Const.Color.primary
            $0.tintColor = .white
            $0.layer.cornerRadius = 5.0
        }.snp.makeConstraints { make in
            make.top.width.height.equalTo(dailyChartButton)
            make.leading.equalTo(dailyChartButton.snp.trailing).offset(5)
        }
    }
    func setChart() {
        lineChartView.extraRightOffset = 30
        
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(dailyChartButton.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    func setAllTransactionsTable() {
        allTransactionHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10.0)
            make.top.equalTo(viewChart.snp.bottom).offset(30.0)
        }
        
        allTransactionTable.addSubview(stackView)
        
        allTransactionTable.snp.makeConstraints { make in
            make.left.right.equalTo(allTransactionHeader)
            make.top.equalTo(allTransactionHeader.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        stackView.then {
            $0.axis = .vertical
            $0.spacing = 1.0
            $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
        }.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func setBinding() {
        let output = viewModel.transform(input: HomeVM.Input(
            isHourlyTapped: hourlyChartButton.rx.tapGesture().when(.recognized).asObservable(),
            isDailyTapped: dailyChartButton.rx.tapGesture().when(.recognized).asObservable(),
            isMonthlyTapped: monthlyChartButton.rx.tapGesture().when(.recognized).asObservable()
        ))
        
        output.transactions.subscribe(onNext: { transactions in
            self.loadingIndicatorView.stopAnimating()
            let transactions = transactions.sorted(by: { $0.Transaction.registeredDate > $1.Transaction.registeredDate })
            
            transactions.forEach { transaciton in
                let data = transaciton.Transaction
                
                let supplierInfo = self.supplierRepository.getSupplierInfo(id: Int(data.supplier)!).asObservable()
                
                if data.buyer != nil {
                    let buyerInfo = self.buyerRepository.getBuyerInfo(id: Int(data.buyer!)!).asObservable()
                    
                    Observable.combineLatest(buyerInfo,supplierInfo)
                        .subscribe(onNext: { (buyer, supplier) in
                            self.stackView.addArrangedSubview(
                                TransactionCell(
                                    input: data,
                                    supplier: supplier.name,
                                    buyer: buyer.name
                                ))
                        }).disposed(by: self.disposeBag)
                } else {
                    supplierInfo.subscribe(onNext: { supplier in
                            self.stackView.addArrangedSubview(
                                TransactionCell(
                                    input: data,
                                    supplier: supplier.name,
                                    buyer: "-"
                                )
                            )
                    }).disposed(by: self.disposeBag)
                }
            }
        }).disposed(by: disposeBag)
        
        output.chartData.subscribe(onNext: { chartData in
            self.setChartData(dataPoints: chartData.xData, values: chartData.yData, limit: chartData.average)
        }).disposed(by: disposeBag)
    }
    
    func setChartData(dataPoints: [String], values: [Double], limit: Double) {
        // 데이터 생성
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "판매량").then {
            $0.drawCirclesEnabled = false
            $0.colors = [.systemBlue]
            $0.lineWidth = 2
            $0.mode = .linear
            let gradientColors = [
                UIColor.systemBlue.withAlphaComponent(0).cgColor,
                UIColor.systemBlue.withAlphaComponent(1).cgColor
            ]
            let gradient = CGGradient(
                colorsSpace: nil,
                colors: gradientColors as CFArray,
                locations: nil
            )!
            
            $0.fill = LinearGradientFill(gradient: gradient, angle: 90)
            $0.fillAlpha = 0.8
            $0.drawFilledEnabled = true
            $0.drawHorizontalHighlightIndicatorEnabled = false
//            $0.highlightColor = .systemRed
            $0.highlightEnabled = false
        }
        
        // 데이터 삽입
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)      // value 표시 유무
        
//        let ll = ChartLimitLine(limit: limit, label: "average")
//        ll.labelPosition = .leftTop
//        ll.drawLabelEnabled = true
//        ll.lineColor = .gray.withAlphaComponent(0.3)
//        ll.lineDashLengths = [5, 5, 0]
//        ll.valueTextColor = .gray
//        lineChartView.leftAxis.addLimitLine(ll)

        lineChartView.data = chartData
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints) // X축 레이블 포맷 지정
        lineChartView.xAxis.setLabelCount(dataPoints.count-1, force: false)
        lineChartView.animate(yAxisDuration: 0.25, easing: .none)
    }
}
