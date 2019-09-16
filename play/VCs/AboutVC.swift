//
//  AboutVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 16/09/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class AboutVC: UIViewController
{
    
    @IBOutlet weak var textview: UITextView!
    
    override func viewDidLoad()
    {
        fillText()
    }
    
    func fillText()
    {
        var text="Aplicația Items Planner este un program de gestiune destinat Godmother.ro \n\n Fiecare obiect aparține unei categorii, și conține informații ce pot fi editate de către administrator. Rezervările efectuate asupra obiectelor se publică cu o perioadă de calendar, o cantitate numerică și o descriere. În panoul principal, obiectele listate pot fi filtrate după categorie sau după generarea unei căutări. \n În secțiunea de rezervări personale, puteți vedea o listă completă cu toate rezervările dvs., avand posibilitea de editare completă cât și ștergere. \n\n Godmother.ro deține drepturile complete asupra aplicației prezente. \n\n Pentru orice eroare sau neconformitate apărută în aplicație în mediul iOS, vă rog să raportați cu detalii cât mai complete."
        
        self.textview.text = text
    }
}
