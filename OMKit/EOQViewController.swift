//
//  EOQViewController.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit
import iosMath

class EOQViewController: UIViewController {
    
    var alertController:UIAlertController? = nil
        
    // @IBOutlet weak var scrollView: UIScrollView!
    // input UITextFields
    @IBOutlet weak var eoqRVariable: UITextField!
    @IBOutlet weak var eoqSVariable: UITextField!
    @IBOutlet weak var eoqPVariable: UITextField!
    @IBOutlet weak var eoqHVariable: UITextField!
    
    // solution UI Labels
    @IBOutlet weak var eoqOptimalOrderQuantity: UILabel!
    @IBOutlet weak var eoqHoldingOrderingCosts: UILabel!
    @IBOutlet weak var eoqTotalCost: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Economic Order Model"
    }
    
    override func viewDidLoad() {
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        //let formulaRect = setEOQFormulaRect()
        
        // displays EOQ formula using Latex Pod, adds view to VC
        //let eoqFormula: MTMathUILabel = MTMathUILabel(frame: formulaRect!)
        //eoqFormula.latex = "\\sqrt{\\frac{2*R*S}{H}} = Q^*"
        //eoqFormula.fontSize = 15
        //self.view.addSubview(eoqFormula)
        
        // hide result text labels
        eoqOptimalOrderQuantity.isHidden = true
        eoqHoldingOrderingCosts.isHidden = true
        eoqTotalCost.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func eoqCalculate(_ sender: Any) {
        // check to make sure each textfield is filled; if not, present alert; if so, continue
        if eoqRVariable.text?.isEmpty ?? true || eoqSVariable.text?.isEmpty ?? true || eoqPVariable.text?.isEmpty ?? true || eoqHVariable.text?.isEmpty ?? true {
            
            self.alertController = UIAlertController(title: "Error", message: "You must enter values for all fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
            
        } else {
            eoqModelSolution()
        }
    }
    
    
    @IBAction func eoqClearButton(_ sender: Any) {
        eoqRVariable.text = ""
        eoqSVariable.text = ""
        eoqPVariable.text = ""
        eoqHVariable.text = ""
        
        eoqOptimalOrderQuantity.isHidden = true
        eoqHoldingOrderingCosts.isHidden = true
        eoqTotalCost.isHidden = true
    }
    
    func eoqModelSolution() {
        // convert input variables to Doubles
        var eoqRVariableDouble: Double = Double(eoqRVariable.text!)!
        var eoqSVariableDouble: Double = Double(eoqSVariable.text!)!
        var eoqHVariableDouble: Double = Double(eoqHVariable.text!)!
        var eoqPVariableDouble: Double = Double(eoqPVariable.text!)!
        
        // calculate optimal order quantity for use in cost functions
        var eoqSolution: Double = economicOrderQuantitySolve(R: eoqRVariableDouble, S: eoqSVariableDouble, H: eoqHVariableDouble)
        
        // EOQ Optimal Order Quantity Formatted function call, label reveal
        eoqOptimalOrderQuantity.text = economicOrderQuantitySolveFormatted(R: eoqRVariableDouble, S: eoqSVariableDouble, H: eoqHVariableDouble)
        eoqOptimalOrderQuantity.isHidden = false
        
        // EOQ Holding & Ordering costs function call, label reveal
        eoqHoldingOrderingCosts.text = economicOrderQuantityHoldOrderSolveFormatted(eoqSolution: eoqSolution, R: eoqRVariableDouble, S: eoqSVariableDouble, H: eoqHVariableDouble)
        eoqHoldingOrderingCosts.isHidden = false
        
        // EOQ Total Costs function call, label reveal
        eoqTotalCost.text = economicOrderQuantityTotalCostsFormatted(eoqSolution: eoqSolution, R: eoqRVariableDouble, S: eoqSVariableDouble, H: eoqHVariableDouble, P: eoqPVariableDouble)
        eoqTotalCost.isHidden = false
    }
    
    func economicOrderQuantitySolve(R: Double, S: Double, H: Double) -> Double {
        let eoqModel = (2*R*S)/(H)
        let eoqSolution = Double(eoqModel.squareRoot())
        return eoqSolution
    }
    
    func economicOrderQuantitySolveFormatted(R: Double, S: Double, H: Double) -> String {
        let eoqModel = (2*R*S)/(H)
        let eoqSolution = Double(eoqModel.squareRoot())
        return formatMathSolution(value: eoqSolution)
    }
    
    func economicOrderQuantityHoldOrderSolveFormatted(eoqSolution: Double, R: Double, S: Double, H: Double) -> String {
        let eoqHoldOrderCosts = (H*(eoqSolution/2)) + (S*(R/eoqSolution))
        return formatCurrencyUSD(value: eoqHoldOrderCosts)
    }
    
    func economicOrderQuantityTotalCostsFormatted(eoqSolution: Double, R: Double, S: Double, H: Double, P: Double) -> String {
        let eoqTotalCosts = (H*(eoqSolution/2)) + (S*(R/eoqSolution)) + (P*R)
        return formatCurrencyUSD(value: eoqTotalCosts)
    }
    
    func setEOQFormulaRect() -> CGRect? {
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

    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let eoqInfoViewController = segue.destination as? eoqInfoViewController {

            // How to retitle "Back" button so it doesn't just inherent the title of the last screen
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

// Code to dismiss keyboard when tapped around
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
