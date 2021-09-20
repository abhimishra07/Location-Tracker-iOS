//
//  MainPageViewController.swift
//  Location Manager
//
//  Created by Anu on 17/09/21.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet var yesButtonPressed: UIButton!

    @IBAction func yesButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButtonPressed.layer.cornerRadius = yesButtonPressed.bounds.size.width/2
        yesButtonPressed.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
