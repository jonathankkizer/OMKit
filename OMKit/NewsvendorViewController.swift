//
//  NewsvendorViewController.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/23/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit
import SigmaSwiftStatistics

class NewsvendorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var alertController:UIAlertController? = nil
    
    @IBOutlet weak var newsvendorDistPicker: UIPickerView!
    @IBOutlet weak var newsvendorMu: UITextField!
    @IBOutlet weak var newsvendorSigma: UITextField!
    @IBOutlet weak var newsvendorCostUnderage: UITextField!
    @IBOutlet weak var newsvendorCostOverage: UITextField!
    @IBOutlet weak var criticalRatioLabel: UILabel!
    @IBOutlet weak var newsvendorLabel: UILabel!
    var newsvendorProbDist: String = "Normal"
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // picker initializations
        self.newsvendorDistPicker.delegate = self
        self.newsvendorDistPicker.dataSource = self
        pickerData = ["Normal", "Poisson"]
        
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        criticalRatioLabel.isHidden = true
        newsvendorLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        newsvendorProbDist = pickerData[row]
        if newsvendorProbDist == "Poisson" {
            newsvendorMu.placeholder = "λ"
            newsvendorSigma.placeholder = "√λ"
        } else if newsvendorProbDist == "Normal" {
            newsvendorMu.placeholder = "μ"
            newsvendorSigma.placeholder = "σ"
        }
        //print(newsvendorProbDist)
        return pickerData[row]
    }
    
    @IBAction func newsvendorCalculateButtonPress(_ sender: Any) {
        // calculates the standard deviation for poisson distribution, inserts it so it passes the next check
        if (newsvendorProbDist == "Poisson") && (newsvendorMu.text?.isEmpty == false) {
            var intermediateSigma: Double = Double(newsvendorMu.text!)!
            newsvendorSigma.text = formatMathSolution(value: intermediateSigma.squareRoot())
        }
        // checks for empty necessary fields
        if newsvendorMu.text?.isEmpty ?? true || newsvendorSigma.text?.isEmpty ?? true || newsvendorCostUnderage.text?.isEmpty ?? true || newsvendorCostOverage.text?.isEmpty ?? true {
            // configures and presents error alert
            self.alertController = UIAlertController(title: "Error", message: "You must enter values for all fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
            
        } else {
            // solves problem, sets labels to solutions
            newsvendorSolution()
        }
        
    }
    
    @IBAction func newsvendorClearButtonPress(_ sender: Any) {
        newsvendorMu.text = ""
        newsvendorSigma.text = ""
        newsvendorCostOverage.text = ""
        newsvendorCostUnderage.text = ""
        
        criticalRatioLabel.isHidden = true
        newsvendorLabel.isHidden = true
    }
    
    func newsvendorSolution() {
        // create Doubles of text fields
        var newsvendorMuDouble: Double = Double(newsvendorMu.text!)!
        var newsvendorSigmaDouble: Double = Double(newsvendorSigma.text!)!
        var newsvendorCostUnderageDouble: Double = Double(newsvendorCostUnderage.text!)!
        var newsvendorCostOverageDouble: Double = Double(newsvendorCostOverage.text!)!
        
        if newsvendorProbDist == "Normal" {
            var critRatioDouble: Double = Double(newsvendorCostUnderageDouble / (newsvendorCostOverageDouble + newsvendorCostUnderageDouble))
            var critRatioZScore: Double = Sigma.normalQuantile(p: critRatioDouble)!
            var newsvendorQuantityDouble: Double = newsvendorMuDouble + (newsvendorSigmaDouble * critRatioZScore)
            criticalRatioLabel.text = formatMathSolution(value: critRatioDouble)
            newsvendorLabel.text = formatMathSolution(value: newsvendorQuantityDouble)
            criticalRatioLabel.isHidden = false
            newsvendorLabel.isHidden = false
            
        } else if newsvendorProbDist == "Poisson" {
            if newsvendorMuDouble >= Double(1000) {
                var critRatioDouble: Double = Double(newsvendorCostUnderageDouble / (newsvendorCostOverageDouble + newsvendorCostUnderageDouble))
                var critRatioZScore: Double = Sigma.normalQuantile(p: critRatioDouble)!
                var newsvendorQuantityDouble: Double = newsvendorMuDouble + (newsvendorSigmaDouble * critRatioZScore)
                criticalRatioLabel.text = formatMathSolution(value: critRatioDouble)
                newsvendorLabel.text = formatMathSolution(value: newsvendorQuantityDouble)
                criticalRatioLabel.isHidden = false
                newsvendorLabel.isHidden = false
            } else {
                self.alertController = UIAlertController(title: "Error", message: "Poisson distribution λ should be greater than 1000 for accurate results", preferredStyle: UIAlertControllerStyle.alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                }
                self.alertController!.addAction(OKAction)
                self.present(self.alertController!, animated: true, completion:nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
