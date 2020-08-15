//
//  ViewController.swift
//  Scan
//
//  Created by iscopy on 2020/7/15.
//  Copyright © 2020 iscopy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var content: UILabel!
    
    @IBAction func btnScan1(_ sender: Any) {
        let scan = ScanController()
        //将传过来的值  赋给label
        scan.sendScans = { (strings : String, type : String) -> Void in
            print("\(strings)\(type)")
            self.content.text = strings
        }
        scan.type = "CribCode"
        scan.modalPresentationStyle = .fullScreen
        self.present(scan, animated: true, completion: nil)
    }
    @IBAction func btnScan2(_ sender: Any) {
        let scan = Scan2Controller()
        //将传过来的值  赋给label
        scan.sendScans = { (strings : String, type : String) -> Void in
            print("\(strings)\(type)")
            self.content.text = strings
        }
        scan.type = "CribCode"
        scan.modalPresentationStyle = .fullScreen
        self.present(scan, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the vie.w
    }


}

