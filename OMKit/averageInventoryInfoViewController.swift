//
//  miscellanousInfoViewController.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/21/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import UIKit

class averageInventoryInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.title = "About Average Inventory"
        //Get the first (and only) subview of the scrollView.
        
        //Make the scroll view's contentSize the same size as the content view.
        //theScrollView!.contentSize = subview.bounds.size;

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
