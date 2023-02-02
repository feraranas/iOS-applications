//
//  SecondController.swift
//  FirstApp
//
//  Created by Fernando Arana on 15/01/23.
//

import UIKit

class SecondController: UIViewController {
    
    
    @IBOutlet weak var Label1: UILabel!
    
    @IBOutlet weak var Label2: UILabel!
    
    @IBOutlet weak var Label3: UILabel!
    
    @IBOutlet weak var PressMe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Label1.text = "Hello, World!"
        Label2.text = "Hello, Fer!"
        Label3.text = "Hello, Swift!"
    }
    
    
    @IBAction func PressedButton(_ sender: Any) {
        Label1.text = "Goodbye, World!"
        Label2.text = "Goodbye, Fer!"
        Label3.text = "Goodbye, Swift!"
    }
}

