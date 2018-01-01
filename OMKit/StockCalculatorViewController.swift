//
//  StockCalculatorViewController.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit
//import iosMath
import SigmaSwiftStatistics

class StockCalculatorViewController: UIViewController {
    
    var alertController:UIAlertController? = nil

    @IBOutlet weak var leadTimeMuLabel: UILabel!
    
    @IBOutlet weak var servicePercentile: UITextField!
    @IBOutlet weak var demandMu: UITextField!
    @IBOutlet weak var demandSigma: UITextField!
    @IBOutlet weak var leadTimeMu: UITextField!
    @IBOutlet weak var leadTimeSigma: UITextField!
    @IBOutlet weak var leadTimeLabel: UILabel!
    @IBOutlet weak var safetyStockSolution: UILabel!
    @IBOutlet weak var unitCost: UITextField!
    @IBOutlet weak var safetyStockTotalCostLabel: UILabel!
    
    @IBOutlet weak var safetyStockFormulaImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Safety Stock"
        iOS11NavBarDesign()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // hide optional labels/fields & solution field
        leadTimeSigma.isHidden = true
        leadTimeLabel.isHidden = true
        safetyStockSolution.isHidden = true
        safetyStockTotalCostLabel.isHidden = true
        
        iOS11NavBarDesign()
        
        //var safetyStockFormulaRect = setSafetyFormulaRectToggleEnabled()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func constantLeadTimeToggle(_ sender: Any) {
        if leadTimeSigma.isHidden == true {
            leadTimeSigma.isHidden = false
            leadTimeLabel.isHidden = false
            //var safetyStockFormulaRect = setSafetyFormulaRectToggleDisabled()
            // call to function or draw equation using this CGRect
            
            leadTimeMuLabel.text? = "Lead Time μ:"
            
            // change formula based on which is relevant
            var formulaUnknownLT: UIImage = UIImage(named: "safetyStockUnknownLT")!
            safetyStockFormulaImage.image = formulaUnknownLT
            
        } else {
            leadTimeSigma.isHidden = true
            leadTimeLabel.isHidden = true
            //var safetyStockFormulaRect = setSafetyFormulaRectToggleEnabled()
            // call to function or draw equation using this CGRect
            
            leadTimeMuLabel.text? = "Lead Time:"
            
            // change formula based on which is relevant
            var formulaKnownLT: UIImage = UIImage(named: "safetyStockKnownLT")!
            safetyStockFormulaImage.image = formulaKnownLT
        }
    }
    
    
    @IBAction func safetyStockCalculatePress(_ sender: Any) {
        
        if servicePercentile.text?.isEmpty ?? true || demandMu.text?.isEmpty ?? true || demandSigma.text?.isEmpty ?? true || leadTimeMu.text?.isEmpty ?? true || unitCost.text?.isEmpty ?? true {
            
            self.alertController = UIAlertController(title: "Error", message: "You must enter values for all fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
            
        } else {
            safetyStockSolver()
        }
        
    }
    
    @IBAction func safetyStockClearPress(_ sender: Any) {
        servicePercentile.text? = ""
        demandMu.text? = ""
        demandSigma.text? = ""
        leadTimeMu.text? = ""
        leadTimeSigma.text? = ""
        safetyStockSolution.isHidden = true
        unitCost.text? = ""
        safetyStockTotalCostLabel.text? = ""
    }
    
    func safetyStockSolver() {
        // convert values to Double
        var servicePercentileDouble: Double = Double(servicePercentile.text!)!
        // percentile should be less than 1
        if servicePercentileDouble > 1 {
            servicePercentileDouble = servicePercentileDouble/100
        }
        let demandMuDouble: Double = Double(demandMu.text!)!
        let demandSigmaDouble: Double = Double(demandSigma.text!)!
        let leadTimeMuDouble: Double = Double(leadTimeMu.text!)!
        let leadTimeSigmaDouble: Double = setLeadTimeSigmaDouble()
        let unitCostDouble: Double = Double(unitCost.text!)!
        
        
        // calculate ZScore
        let zScore: Double = percentileToZScore(percentile: servicePercentileDouble)
        
        // solution calculation
        if leadTimeSigma.isHidden == true {
            // calculate safety stock with constant lead time
            var safetyStock: Double = safetyStockKnownLeadtime(zScore: zScore, leadTime: leadTimeMuDouble, demandSigma: demandSigmaDouble)
            if safetyStock < 0 {
                safetyStock = Double(0)
            }
            safetyStockSolution.text? = formatMathSolution(value: safetyStock)
            safetyStockTotalCostLabel.text? = formatCurrencyUSD(value: (safetyStock * unitCostDouble))
        } else if leadTimeSigma.isHidden == false {
            // calculate safety stock with variable lead time
            var safetyStock: Double = safetyStockUnknownLeadtime(zScore: zScore, leadTimeMu: leadTimeMuDouble, leadTimeSigma: leadTimeSigmaDouble, demandMu: demandMuDouble, demandSigma: demandSigmaDouble)
            if safetyStock < 0 {
                safetyStock = Double(0)
            }
            safetyStockSolution.text? = formatMathSolution(value: safetyStock)
            safetyStockTotalCostLabel.text? = formatCurrencyUSD(value: (safetyStock * unitCostDouble))
        }
        safetyStockSolution.isHidden = false
        safetyStockTotalCostLabel.isHidden = false
    }
    
    func setLeadTimeSigmaDouble() -> Double {
        if leadTimeSigma.isHidden == true {
            return Double(1)
        } else {
            let leadTimeSigmaDouble: Double = Double(leadTimeSigma.text!)!
            return leadTimeSigmaDouble
        }
    }
    
    func safetyStockKnownLeadtime(zScore: Double, leadTime: Double, demandSigma: Double) -> Double {
        let safetyStock: Double = zScore * (leadTime.squareRoot() * demandSigma)
        return safetyStock
    }
    
    func safetyStockUnknownLeadtime(zScore: Double, leadTimeMu: Double, leadTimeSigma: Double, demandMu: Double, demandSigma: Double) -> Double {
        let beforeZScore: Double = ((leadTimeMu * (pow(demandSigma, Double(2)))) + ((pow(demandMu, Double(2))) * (pow(leadTimeSigma, Double(2))))).squareRoot()
        let safetyStock: Double = zScore * beforeZScore
        return safetyStock
    }
    
    func percentileToZScore(percentile: Double) -> Double {
        let zScore: Double = Sigma.normalQuantile(p: percentile, μ: 0, σ: 1)!
        print("Z Score: ", zScore)
        return zScore
    }
    
    // TO DO: UPDATE THIS BASED ON SAFETY STOCK NEEDS
    func setSafetyFormulaRectToggleEnabled() -> CGRect? {
        let deviceScreenType = getDeviceScreenType()
        if deviceScreenType == "iPhone4.7" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 207.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone5.8" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 232.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone4.0" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 207.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone5.5" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 207.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        }
        return nil
    }
    
    // TO DO: UPDATE THIS BASED ON SAFETY STOCK NEEDS
    func setSafetyFormulaRectToggleDisabled() -> CGRect? {
        let deviceScreenType = getDeviceScreenType()
        if deviceScreenType == "iPhone4.7" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 207.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone5.8" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 232.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone4.0" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 207.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone5.5" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 207.5),
                                     size:CGSize(width:150, height:100))
            return formulaRect
        }
        return nil
    }
    
    func iOS11NavBarDesign() {
        let deviceType: String = getDeviceScreenType()
        if deviceType == "iPhone5.8" || deviceType == "iPhone5.5" || deviceType == "iPhone4.7" {
            self.navigationController?.navigationBar.topItem?.title = "Safety Stock"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let stockCalculatorInfoViewController = segue.destination as? stockCalculatorInfoViewController {
            // How to retitle "Back" button so it doesn't just inherent the title of the last screen
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
