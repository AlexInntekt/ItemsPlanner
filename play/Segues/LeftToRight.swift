
import Foundation
import UIKit

class LeftToRight: UIStoryboardSegue
{
    
    
    override func perform()
    {
        let firstVCView = self.source.view as UIView!
        let secondVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        
        secondVCView!.frame = CGRect( x:screenWidth, y:0.0, width:screenWidth, height:screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration:0.3, animations: { () -> Void in
            firstVCView!.frame = firstVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            secondVCView!.frame = secondVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController,
                                animated: false,
                                completion: nil)
        }
    }
    
}
