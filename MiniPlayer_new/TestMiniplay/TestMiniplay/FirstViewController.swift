//
//  FirstViewController.swift
//  TestWindow
//
//  Created by Nguyen Tuan on 7/30/15.
//  Copyright (c) 2015 pk.atc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 45)
        button.setTitle("Button1", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func pressed(sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.showOrHidePopupWindow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

