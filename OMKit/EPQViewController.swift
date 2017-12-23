//
//  EPQViewController.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit
//import iosMath

class EPQViewController: UIViewController {

    var alertController:UIAlertController? = nil
    
    // epq variable inputs
    @IBOutlet weak var epqRVariable: UITextField!
    @IBOutlet weak var epqKVariable: UITextField!
    @IBOutlet weak var epqSVariable: UITextField!
    @IBOutlet weak var epqPVariable: UITextField!
    @IBOutlet weak var epqHVariable: UITextField!
    
    //epq output labels
    @IBOutlet weak var epqOptimalOrderQuantity: UILabel!
    @IBOutlet weak var epqOrderHoldCosts: UILabel!
    @IBOutlet weak var epqTotalCost: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Economic Production Model"
    }
    
    override func viewDidLoad() {
        //self.navigationController?.navigationBar.barTintColor = UIColor.green
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // set formula rect, draw latex formula, insert subview
        //let formulaRect = setEPQFormulaRect()
        //let epqFormula: MTMathUILabel = MTMathUILabel(frame: formulaRect!)
        //epqFormula.latex = "\\sqrt{\\frac{2*R*S}{H}}*\\sqrt{\\frac{K}{K-R}} = Q^*"
        //epqFormula.fontSize = 15
        //self.view.addSubview(epqFormula)
        
        
        // hide solution labels
        epqOptimalOrderQuantity.isHidden = true
        epqOrderHoldCosts.isHidden = true
        epqTotalCost.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func epqCalculate(_ sender: Any) {
        
        // check to make sure each textfield is filled; if not, present alert; if so, continue
        if epqRVariable.text?.isEmpty ?? true || epqSVariable.text?.isEmpty ?? true || epqPVariable.text?.isEmpty ?? true || epqHVariable.text?.isEmpty ?? true || epqKVariable.text?.isEmpty ?? true {
            
            self.alertController = UIAlertController(title: "Error", message: "You must enter values for all fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
            
        } else {
            // conver text field values into doubles
            var epqRVariableDouble: Double = Double(epqRVariable.text!)!
            var epqSVariableDouble: Double = Double(epqSVariable.text!)!
            var epqHVariableDouble: Double = Double(epqHVariable.text!)!
            var epqPVariableDouble: Double = Double(epqPVariable.text!)!
            var epqKVariableDouble: Double = Double(epqKVariable.text!)!

            if (epqKVariableDouble <= epqRVariableDouble) {
                self.alertController = UIAlertController(title: "Error", message: "Solution results in imaginary number or divide by zero error; make sure that time is constant across values.", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                }
                self.alertController!.addAction(OKAction)
                self.present(self.alertController!, animated: true, completion:nil)
            } else {
                epqModelSolution(epqRVariableDouble: epqRVariableDouble, epqSVariableDouble: epqSVariableDouble, epqHVariableDouble: epqHVariableDouble, epqPVariableDouble: epqPVariableDouble, epqKVariableDouble: epqKVariableDouble)
            }
        }
    }
    
    
    @IBAction func epqClearTap(_ sender: Any) {
        epqRVariable.text = ""
        epqSVariable.text = ""
        epqPVariable.text = ""
        epqHVariable.text = ""
        epqKVariable.text = ""
        
        epqOptimalOrderQuantity.isHidden = true
        epqOrderHoldCosts.isHidden = true
        epqTotalCost.isHidden = true
    }
    
    func epqModelSolution(epqRVariableDouble: Double, epqSVariableDouble: Double, epqHVariableDouble: Double, epqPVariableDouble: Double, epqKVariableDouble: Double) {
        // calculate optimal order quantity for use in cost functions
        var epqSolution: Double = economicProductionQuantitySolve(R: epqRVariableDouble, S: epqSVariableDouble, H: epqHVariableDouble, K: epqKVariableDouble)
        
        // EOQ Optimal Order Quantity Formatted function call, label reveal
        epqOptimalOrderQuantity.text = economicProductionQuantitySolveFormatted(R: epqRVariableDouble, S: epqSVariableDouble, H: epqHVariableDouble, K: epqKVariableDouble)
        epqOptimalOrderQuantity.isHidden = false
        
        // EOQ Holding & Ordering costs function call, label reveal
        epqOrderHoldCosts.text = economicProductionQuantityHoldOrderSolveFormatted(epqSolution: epqSolution, R: epqRVariableDouble, S: epqSVariableDouble, H: epqHVariableDouble, K: epqKVariableDouble)
        epqOrderHoldCosts.isHidden = false
        
        // EOQ Total Costs function call, label reveal
        epqTotalCost.text = economicProductionQuantityTotalCostsFormatted(epqSolution: epqSolution, R: epqRVariableDouble, S: epqSVariableDouble, H: epqHVariableDouble, P: epqPVariableDouble, K: epqKVariableDouble)
        epqTotalCost.isHidden = false
    }
    
    func economicProductionQuantitySolve(R: Double, S: Double, H: Double, K: Double) -> Double {
        let epqPtOne = (2*R*S)/(H)
        let epqPtTwo = (K/(K-R))
        let epqSolution = Double(epqPtOne.squareRoot()*epqPtTwo.squareRoot())
        return epqSolution
    }
    
    func economicProductionQuantitySolveFormatted(R: Double, S: Double, H: Double, K: Double) -> String {
        let epqPtOne = (2*R*S)/(H)
        let epqPtTwo = (K/(K-R))
        let epqSolution = Double(epqPtOne.squareRoot()*epqPtTwo.squareRoot())
        return formatMathSolution(value: epqSolution)
    }
    
    func economicProductionQuantityHoldOrderSolveFormatted(epqSolution: Double, R: Double, S: Double, H: Double, K: Double) -> String {
        let epqHoldOrderCosts = ((H*(epqSolution/2))*(K-R)/K) + (S*(R/epqSolution))
        return formatCurrencyUSD(value: epqHoldOrderCosts)
    }
    
    func economicProductionQuantityTotalCostsFormatted(epqSolution: Double, R: Double, S: Double, H: Double, P: Double, K: Double) -> String {
        let epqTotalCosts = ((H*(epqSolution/2))*(K-R)/K) + (S*(R/epqSolution)) + (P*R)
        return formatCurrencyUSD(value: epqTotalCosts)
    }
    
    func setEPQFormulaRect() -> CGRect? {
        let deviceScreenType = getDeviceScreenType()
        if deviceScreenType == "iPhone4.7" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 237.5),
                                     size:CGSize(width:200, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone5.8" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 267.5),
                                     size:CGSize(width:200, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone4.0" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 237.5),
                                     size:CGSize(width:200, height:100))
            return formulaRect
        } else if deviceScreenType == "iPhone5.5" {
            let formulaRect = CGRect(origin: CGPoint(x: 10, y: 237.5),
                                     size:CGSize(width:200, height:100))
            return formulaRect
        }
        return nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let epqInfoViewController = segue.destination as? epqInfoViewController {
            // How to retitle "Back" button so it doesn't just inherent the title of the last screen
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
