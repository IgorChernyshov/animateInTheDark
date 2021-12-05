//
//  TabBarController.swift
//  animateInTheDark
//
//  Created by Igor Chernyshov on 05.12.2021.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let firstTabController = UINavigationController(rootViewController: MorphingSquareController())
		firstTabController.tabBarItem = UITabBarItem(title: "Square", image: UIImage(systemName: "square.fill"), tag: 0)
		let secondTabController = UINavigationController(rootViewController: YellingGooseController())
		secondTabController.tabBarItem = UITabBarItem(title: "Goose", image: UIImage(systemName: "swift"), tag: 1)
		viewControllers = [firstTabController, secondTabController]
	}
}
