//
//  ViewController.swift
//  AYSegmentedControlsDemo
//
//  Created by User on 2019/7/11.
//  Copyright © 2019 JerryYou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var segmentedControlsTitles = ["First", "Second", "Third"]
    var segmentedControls2Titles = ["Swift", "Objective-C"]
    var segmentedControls3Titles = ["1", "2", "3", "4"]
    
    @IBOutlet weak var segmentedControls1: AYSegmentedControls!
    @IBOutlet weak var segmentedControls2: AYSegmentedControls!
    @IBOutlet weak var segmentedControls3: AYSegmentedControls!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControls()
        setupSegmentedControls2()
        setupSegmentedControls3()
    }
    
    ///Default
    private func setupSegmentedControls() {
        segmentedControls1.dataSource = self
        segmentedControls1.delegate = self
    }
    
    ///Custom
    private func setupSegmentedControls2() {
        segmentedControls2.hintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        segmentedControls2.borderWidth = 2
        segmentedControls2.bordrColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        segmentedControls2.titleFont = UIFont.systemFont(ofSize: 20)
        segmentedControls2.normalTitleColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        segmentedControls2.selectedTitleColor = UIColor.white
        segmentedControls2.dataSource = self
        segmentedControls2.delegate = self
    }
    
    private func setupSegmentedControls3() {
        segmentedControls3.dataSource = self
        segmentedControls3.delegate = self
    }
    
    @IBAction func numberButtonTapped(_ button: UIButton) {
        segmentedControls3.selectIndex(at: button.tag, animated: true)
    }
    
}

extension ViewController: AYSegmentedControlsDataSource {

    func numberOfSegmented(in segmentedControls: AYSegmentedControls) -> Int {
        var count = 0
        if segmentedControls == segmentedControls1 {
            count = segmentedControlsTitles.count
        } else if segmentedControls == segmentedControls2 {
            count = segmentedControls2Titles.count
        } else if segmentedControls == segmentedControls3 {
            count = segmentedControls3Titles.count
        }
        return count
    }
    
    func segmentedControls(_ segmentedControls: AYSegmentedControls,
                           titleForSegmentedAt index: Int) -> String {
        var title = ""
        if segmentedControls == segmentedControls1 {
            title = segmentedControlsTitles[index]
        } else if segmentedControls == segmentedControls2 {
            title = segmentedControls2Titles[index]
        } else if segmentedControls == segmentedControls3 {
            title = segmentedControls3Titles[index]
        }
        return title
    }
    
}

extension ViewController: AYSegmentedControlsDelegate {
    func segmentedControls(_ segmentedControls: AYSegmentedControls,
                           didSelectItemAt index: Int) {
        if segmentedControls == segmentedControls1 {
            print(segmentedControlsTitles[index])
        } else if segmentedControls == segmentedControls2 {
            print(segmentedControls2Titles[index])
        } else if segmentedControls == segmentedControls3 {
            print(segmentedControls3Titles[index])
        }
    }
}



