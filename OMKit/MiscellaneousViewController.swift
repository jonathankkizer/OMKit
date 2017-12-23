//
//  AboutViewController.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit

class MiscellaneousViewController: UIViewController {
    
    
    @IBOutlet weak var theScrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Miscellaneous"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get the first (and only) subview of the scrollView.
        let subview = theScrollView.subviews[0] as! UIView;
        
        //Make the scroll view's contentSize the same size as the content view.
        theScrollView!.contentSize = subview.bounds.size;
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
