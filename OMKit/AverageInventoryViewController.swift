//
//  AboutViewController.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit
import SigmaSwiftStatistics

class AverageInventoryViewController: UIViewController {
    
    var alertController:UIAlertController? = nil
    
    @IBOutlet weak var currentInventoryLevel: UITextField!
    @IBOutlet weak var currentNumLocations: UITextField!
    @IBOutlet weak var projectedNumLocations: UITextField!
    @IBOutlet weak var projectedInventoryLevel: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Average Inventory Level"
        iOS11NavBarDesign()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        iOS11NavBarDesign()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ailCalculateButtonPress(_ sender: Any) {
        var blankButtonCheck: Bool = ailBlankCheck()
        if blankButtonCheck == false {
            self.alertController = UIAlertController(title: "Error", message: "Enter a value for all but Projected Inventory Level.", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
        } else {
            if currentInventoryLevel.text == "" {
                // solve for current inventory level
                self.alertController = UIAlertController(title: "Error", message: "Enter a value for all but Projected Inventory Level.", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                }
                self.alertController!.addAction(OKAction)
                self.present(self.alertController!, animated: true, completion:nil)
                
                
            } else if currentNumLocations.text == "" {
                // solve for current number of locations
                self.alertController = UIAlertController(title: "Error", message: "Enter a value for all but Projected Inventory Level.", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                }
                self.alertController!.addAction(OKAction)
                self.present(self.alertController!, animated: true, completion:nil)
                
                
            } else if projectedNumLocations.text == "" {
                // solve for projected number of locations
                self.alertController = UIAlertController(title: "Error", message: "Enter a value for all but Projected Inventory Level.", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                }
                self.alertController!.addAction(OKAction)
                self.present(self.alertController!, animated: true, completion:nil)
                
                
            } else if projectedInventoryLevel.text == "" {
                // solve for projected inventory level
                var currentInventoryLevelDouble: Double = Double(currentInventoryLevel.text!)!
                var currentNumLocationsDouble: Double = Double(currentNumLocations.text!)!
                var projectedNumLocationsDouble: Double = Double(projectedNumLocations.text!)!
                var projectedInventoryLevelDouble: Double
                
                projectedInventoryLevelDouble = currentInventoryLevelDouble * (projectedNumLocationsDouble/currentNumLocationsDouble).squareRoot()
                projectedInventoryLevel.text = formatMathSolution(value: projectedInventoryLevelDouble)
                
            }
        }
    }
    
    
    @IBAction func ailClearButtonPress(_ sender: Any) {
        currentInventoryLevel.text = ""
        currentNumLocations.text = ""
        projectedNumLocations.text = ""
        projectedInventoryLevel.text = ""
    }
    
    func ailBlankCheck() -> Bool {
        var blankCount: Int = 0
        let ailOutletsArray = [currentInventoryLevel, currentNumLocations, projectedNumLocations, projectedInventoryLevel]
        
        for i in ailOutletsArray {
            if i!.text == "" {
                blankCount += 1
            }
        }
        
        print(blankCount)
        if blankCount > 1 {
            return false
        } else {
            return true
        }
    }
    
    func iOS11NavBarDesign() {
        let deviceType: String = getDeviceScreenType()
        if deviceType == "iPhone5.8" || deviceType == "iPhone5.5" || deviceType == "iPhone4.7" || deviceType == "iPad12.9" || deviceType == "iPad10.5" || deviceType == "iPad9.7" {
            self.navigationController?.navigationBar.topItem?.title = "Inventory Level"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
