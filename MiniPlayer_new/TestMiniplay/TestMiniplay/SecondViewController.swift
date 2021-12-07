//
//  SecondViewController.swift
//  TestWindow
//
//  Created by Nguyen Tuan on 7/30/15.
//  Copyright (c) 2015 pk.atc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 45)
        button.setTitle("Button2", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button2: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button2.frame = CGRect(x: 150, y: 50, width: 100, height: 45)
        button2.setTitle("Push", for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.addTarget(self, action: #selector(push), for: .touchUpInside)
        self.view.addSubview(button2)
    }
    
    @objc func pressed(sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.showOrHidePopupWindow()
    }
    
    @objc func push(sender: AnyObject) {
        let vc = UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

