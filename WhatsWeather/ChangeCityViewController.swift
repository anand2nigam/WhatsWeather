//
//  ChangeCityViewController.swift
//  WhatsWeather
//
//  Created by Anand Nigam on 21/07/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getWeatherButtonPressed(_ sender: UIButton) {
        
        let cityName = changeCityTextField.text
        
        delegate?.userEnteredANewCityName(city: cityName!)
        
        dismiss(animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
