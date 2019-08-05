//
//  UpDownSegue.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 05/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//


import UIKit


class upDownSegue: UIStoryboardSegue
{
    
    
    override func perform()
    {
        let firstVCView = self.destination.view as UIView!
        let secondVCView = self.source.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        
        firstVCView!.frame = CGRect( x:0.0, y:-screenHeight, width:screenWidth, height:screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(firstVCView!, aboveSubview: secondVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration:0.3, animations: { () -> Void in
            firstVCView!.frame = firstVCView!.frame.offsetBy(dx: 0.0, dy: screenHeight)
            secondVCView!.frame = secondVCView!.frame.offsetBy(dx: 0.0, dy: screenHeight)
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController,
                                animated: false,
                                completion: nil)
        }
    }
    
    
    
    
}
