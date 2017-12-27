//
//  QueueViewController
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

//
//  QueueViewController
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit
//import iosMath

class QueueViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var alertController:UIAlertController? = nil
    
    @IBOutlet weak var interarrivalTimesPicker: UIPickerView!
    @IBOutlet weak var processingTimesPicker: UIPickerView!
    @IBOutlet weak var interarrivalTimesMu: UITextField!
    @IBOutlet weak var interarrivalTimesSigma: UITextField!
    @IBOutlet weak var processingTimesMu: UITextField!
    @IBOutlet weak var processingTimesSigma: UITextField!
    @IBOutlet weak var numServers: UITextField!
    @IBOutlet weak var queueTimeSolution: UILabel!
    @IBOutlet weak var inQueueSolution: UILabel!
    @IBOutlet weak var serverUtilizationSolution: UILabel!
    
    
    var interarrivalTimesDist: String = "Normal (μ, σ)"
    var processingTimesDist: String = "Normal (μ, σ)"
    
    var interarrivalPickerData: [String] = [String]()
    var processingPickerData: [String] = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Queue Theory"
    }
    
    override func viewDidLoad() {
        //self.navigationController?.navigationBar.barTintColor = UIColor.green
        super.viewDidLoad()
        self.interarrivalTimesPicker.delegate = self
        self.interarrivalTimesPicker.dataSource = self
        
        self.processingTimesPicker.delegate = self
        self.processingTimesPicker.dataSource = self
        
        interarrivalPickerData = ["Normal (μ, σ)", "Exponential (1/λ)", "Poisson (λ)"]
        processingPickerData = ["Normal (μ, σ)", "Exponential (1/λ)", "Poisson (λ)"]
        updatePlaceHolderText(whichPicker: "interarrivalTimesPicker")
        updatePlaceHolderText(whichPicker: "processingTimesPicker")
        hideKeyboardWhenTappedAround()
        
        queueTimeSolution.isHidden = true
        inQueueSolution.isHidden = true
        serverUtilizationSolution.isHidden = true
        
        // hide solution labels
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interarrivalPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == interarrivalTimesPicker {
            interarrivalTimesDist = interarrivalPickerData[row]
            //print("Interarrival: ", interarrivalTimesDist)
            updatePlaceHolderText(whichPicker: "interarrivalTimesPicker")
        } else if pickerView == processingTimesPicker {
            processingTimesDist = processingPickerData[row]
            //print("Processing: ", processingTimesDist)
            updatePlaceHolderText(whichPicker: "processingTimesPicker")
        }
    }
    
    func updatePlaceHolderText(whichPicker: String) {
        if whichPicker == "interarrivalTimesPicker" {
            if interarrivalTimesDist == "Poisson (λ)" {
                interarrivalTimesMu.placeholder = "λ"
                interarrivalTimesSigma.placeholder = "√λ"
            } else if interarrivalTimesDist == "Normal (μ, σ)" {
                interarrivalTimesMu.placeholder = "μ"
                interarrivalTimesSigma.placeholder = "σ"
            } else if interarrivalTimesDist == "Exponential (1/λ)" {
                interarrivalTimesMu.placeholder = "1/λ"
                interarrivalTimesSigma.placeholder = "1/λ"
            }
        } else if whichPicker == "processingTimesPicker" {
            if processingTimesDist == "Poisson (λ)" {
                processingTimesMu.placeholder = "λ"
                processingTimesSigma.placeholder = "√λ"
            } else if processingTimesDist == "Normal (μ, σ)" {
                processingTimesMu.placeholder = "μ"
                processingTimesSigma.placeholder = "σ"
            } else if processingTimesDist == "Exponential (1/λ)" {
                processingTimesMu.placeholder = "1/λ"
                processingTimesSigma.placeholder = "1/λ"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == interarrivalTimesPicker {
            return interarrivalPickerData[row]
        } else if pickerView == processingTimesPicker {
            return processingPickerData[row]
        }
        return ""
    }
    
    // checks to make sure no necessary blank fields are blank, then solves; if error, presents error
    @IBAction func queueCalculateButtonPress(_ sender: Any) {
        
        // calculates the standard deviation for poisson distribution, inserts it so it passes the next check; same with Exponential distribution (CV = 1)
        if (interarrivalTimesDist == "Poisson (λ)") && (interarrivalTimesMu.text?.isEmpty == false) {
            var intermediateSigma: Double = Double(interarrivalTimesMu.text!)!
            interarrivalTimesSigma.text = formatMathSolution(value: intermediateSigma.squareRoot())
        }
        
        if (processingTimesDist == "Poisson (λ)") && (processingTimesMu.text?.isEmpty == false) {
            var intermediateSigma: Double = Double(processingTimesMu.text!)!
            processingTimesSigma.text = formatMathSolution(value: intermediateSigma.squareRoot())
        }
        
        if (interarrivalTimesDist == "Exponential (1/λ)") && (interarrivalTimesMu.text?.isEmpty == false) {
            interarrivalTimesSigma.text = interarrivalTimesMu.text
        }
        
        if (processingTimesDist == "Exponential (1/λ)") && (processingTimesMu.text?.isEmpty == false) {
            processingTimesSigma.text = processingTimesMu.text
        }
        
        // checks for empty necessary fields
        if interarrivalTimesMu.text?.isEmpty ?? true || interarrivalTimesSigma.text?.isEmpty ?? true || processingTimesMu.text?.isEmpty ?? true || processingTimesSigma.text?.isEmpty ?? true || numServers.text?.isEmpty ?? true {
            // configures and presents error alert
            self.alertController = UIAlertController(title: "Error", message: "You must enter values for all fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
            
        } else {
            // solves problem, sets labels to solutions
            queueTheorySolution()
        }
        
    }
    
    // clears uitextfields, solution labels, and hides solution labels
    @IBAction func queueClearButtonPress(_ sender: Any) {
        interarrivalTimesMu.text = ""
        interarrivalTimesSigma.text = ""
        processingTimesMu.text = ""
        processingTimesSigma.text = ""
        numServers.text = ""
        queueTimeSolution.text = ""
        inQueueSolution.text = ""
        serverUtilizationSolution.text = ""
        
        queueTimeSolution.isHidden = true
        inQueueSolution.isHidden = true
        serverUtilizationSolution.isHidden = true
        
    }
    
    func queueTheorySolution() {
        // convert input variables to Doubles
        var interarrivalTimesMuDouble: Double = Double(interarrivalTimesMu.text!)!
        var interarrivalTimesSigmaDouble: Double = Double(interarrivalTimesSigma.text!)!
        var processingTimesMuDouble: Double = Double(processingTimesMu.text!)!
        var processingTimesSigmaDouble: Double = Double(processingTimesSigma.text!)!
        var numServersDouble: Double = Double(numServers.text!)!
        
        // calculation math
        var utilization: Double = processingTimesMuDouble / (interarrivalTimesMuDouble * numServersDouble)
        var eqPt1: Double = processingTimesMuDouble / numServersDouble
        //print("Equation Part 1: ", eqPt1)
        var eqPt2Numerator: Double = (pow(utilization, ((2*(numServersDouble + 1)).squareRoot()-1)))
        //print("Equation Part 2 Numerator: ", eqPt2Numerator)
        var eqPt2: Double = eqPt2Numerator / (1 - utilization)
        //print("Equation Part 2: ", eqPt2)
        var eqPt3: Double = (pow(interarrivalTimesSigmaDouble/interarrivalTimesMuDouble, 2) + pow(processingTimesSigmaDouble/processingTimesMuDouble, 2)) / 2
        //print("Equation Part 3: ", eqPt3)
        var queueTheorySolutionDouble: Double = eqPt1 * eqPt2 * eqPt3
        
        // formatted solution & answer label insertion
        var utilizationDouble: Double = utilization * Double(100)
        
        var inQueueSolutionDouble: Double = queueTheorySolutionDouble / interarrivalTimesMuDouble
        
        if queueTheorySolutionDouble <= Double(0) {
            queueTheorySolutionDouble = Double(0)
        }
        
        if inQueueSolutionDouble <= Double(0) {
            queueTheorySolutionDouble = Double(0)
        }
        var utilizationFormatted: String = formatMathPercentageSolution(value: utilizationDouble)
        var QueueTheorySolutionFormatted: String = formatMathSolution(value: queueTheorySolutionDouble)
        var inQueueSolutionFormatted: String = formatMathSolution(value: inQueueSolutionDouble)
        queueTimeSolution.text = QueueTheorySolutionFormatted
        inQueueSolution.text = inQueueSolutionFormatted
        serverUtilizationSolution.text = utilizationFormatted
        queueTimeSolution.isHidden = false
        inQueueSolution.isHidden = false
        serverUtilizationSolution.isHidden = false
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let queueInfoViewController = segue.destination as? queueInfoViewController {
            // How to retitle "Back" button so it doesn't just inherent the title of the last screen
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}


