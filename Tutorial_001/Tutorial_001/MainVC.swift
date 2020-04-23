//
//  MainVC.swift
//  Tutorial_001
//
//  Created by 위대연 on 2020/04/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    enum ButtonTAG:Int {
        case start = 10
        case check = 20
        case stop = 30
        case reset = 40
    }
    
    struct timeDatum {
        let time_int:Int
        let time_text:String
    }
    
    @IBOutlet weak var frontTimeLabel:UILabel!
    @IBOutlet weak var backTimeLabel:UILabel!
    
    @IBOutlet weak var checkTableView:UITableView!
    
    @IBOutlet weak var startButton:UIButton!
    @IBOutlet weak var checkButton:UIButton!
    @IBOutlet weak var stopButton:UIButton!
    @IBOutlet weak var resetButton:UIButton!
    
    var checkTableData = Array<timeDatum>()
    var isRunning = false { didSet{ self.updateButton() } }
    
    var timer:Timer?
    
    // timeCount 1은 0.1초
    var timeCount:Int = 0 {
        didSet{
            self.updateTimeLabel(timeCount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonInit()
        self.tableInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateButton()
    }
    
    func tableInit() {
        self.checkTableView.delegate = self
        self.checkTableView.dataSource = self
    }
    
    func createTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (_) in
            self.timeCount += 1
        })
    }
    
    func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func buttonInit() {
        buttonLink(target: self.startButton, tag: .start)
        buttonLink(target: self.checkButton, tag: .check)
        buttonLink(target: self.stopButton, tag: .stop)
        buttonLink(target: self.resetButton, tag: .reset)
    }
    
    func buttonLink(target:UIButton, tag:ButtonTAG) {
        target.tag = tag.rawValue
        target.addTarget(self, action: #selector(touchUpButtons), for: .touchUpInside)
    }
    
    @objc func touchUpButtons(_ sender:UIButton) {
        let selected = ButtonTAG.init(rawValue: sender.tag)
        switch selected {
        case .start: touchUpStartButton(sender)
        case .check: touchUpCheckButton()
        case .stop: touchUpStopButton()
        case .reset: touchUpResetButton()
        default:
            print("touchUpButtons _ 예상치 못한 버튼의 태그가 검출되었다, \(String(describing: selected))")
        }
    }
    
    func updateButton() {
        if isRunning {
            self.startButton.setTitleColor(.gray, for: .normal)
            self.startButton.isEnabled = false
            
            self.checkButton.setTitleColor(.systemBlue, for: .normal)
            self.checkButton.isEnabled = true
            
            self.stopButton.isEnabled = true
            
        } else {
            self.startButton.setTitleColor(.systemBlue, for: .normal)
            self.startButton.isEnabled = true
            
            self.checkButton.setTitleColor(.gray, for: .normal)
            self.checkButton.isEnabled = false
            
            self.stopButton.isEnabled = false
        }
        self.view.layoutIfNeeded()
    }
    
    func updateTimeLabel(_ count:Int) {
        let result = self.makeTimeText(count)
        self.frontTimeLabel.text = result.0
        self.backTimeLabel.text = ".\(result.1)"
        self.view.layoutIfNeeded()
    }
    
    func makeTimeText(_ count:Int) -> (String,String) {
        let decimalS:Int = count % 10
        let sec:Int = (count / 10) % 60
        let min:Int = (count / 10) / 60
        
        let sec_str:String = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let min_str:String = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        let front = String(format: "%@:%@", min_str , sec_str)
        let back = String(format:"%d",decimalS)
        
        return (front, back)
    }
    
    func touchUpStartButton(_ sender:UIButton) {
        print("start button")
        self.isRunning = !self.isRunning
        if isRunning {
            self.createTimer()
        }
    }
    
    func touchUpCheckButton() {
        print("check button")
        let current_count = self.timeCount
        let result = makeTimeText(current_count)
        let datum = timeDatum(time_int: current_count, time_text: String(format: "%@.%@", result.0,result.1))
        self.checkTableData.append(datum)
        
        let indexPath = IndexPath(row: self.checkTableData.count - 1, section: 0)
        self.checkTableView.insertRows(at: [indexPath], with: .automatic)
        self.checkTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //self.checkTableView.reloadData()
    }
    
    func touchUpStopButton() {
        print("stop button")
        self.isRunning = false
        self.removeTimer()
    }
    
    func touchUpResetButton() {
        print("reset button")
        self.isRunning = false
        self.removeTimer()
        self.timeCount = 0
        self.checkTableData.removeAll()
        self.checkTableView.reloadData()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checkTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainCheckCell.reuse_cell_id, for: indexPath) as! MainCheckCell
        
        if checkTableData.count > indexPath.row {
            cell.checkTimeLabel.text = checkTableData[indexPath.row].time_text
        } else {
            cell.checkTimeLabel.text = "Err"
        }
        return cell
    }
}
