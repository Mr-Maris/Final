//
//  ColorsDetailVC.swift
//  SwiftVsSwift
//
//  Created by Maris Rasnacs on 25/02/2021.
//

import UIKit

class ColorsDetailVC: UIViewController {
    
    var color: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }
}
