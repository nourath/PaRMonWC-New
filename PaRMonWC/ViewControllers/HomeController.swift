//
//  PaRMonWC
//
//  Created by Reem Alfaris on 4/8/20.
//  Copyright © 2020 Noura. All rights reserved.
//

// home controller

import UIKit

class HomeController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
    }
    
    private func authorizeHealthKit() {
        HealthKitAssistant.shared.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
}

