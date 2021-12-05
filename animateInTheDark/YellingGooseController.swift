//
//  YellingGooseController.swift
//  animateInTheDark
//
//  Created by Igor Chernyshov on 05.12.2021.
//

import UIKit

final class YellingGooseController: UIViewController {

	// MARK: - Properties
	private var iterationCount = 0
	private var isAnimating = false

	// MARK: - Subviews
	private var gooseView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "goose"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private var startButton: UIBarButtonItem?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.addSubview(gooseView)
		NSLayoutConstraint.activate([
			gooseView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			gooseView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			gooseView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
		])

		startButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(didTapStart))
		startButton?.tintColor = .darkGray
		configureStartButtonImage()
		navigationItem.leftBarButtonItem = startButton
	}

	// MARK: - Tap Actions
	@objc private func didTapStart() {
		isAnimating.toggle()
		configureStartButtonImage()
		guard isAnimating else { return CATransaction.flush() }
		animateGoose()
	}

	// MARK: - UI Configuration
	private func configureStartButtonImage() {
		startButton?.image = isAnimating ? UIImage(systemName: "stop.circle") : UIImage(systemName: "play.circle")
	}

	// MARK: - Animation
	private func animateGoose() {
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			CATransaction.flush()
			guard self.isAnimating else { return }
			self.iterationCount += 1
			self.animateGoose()
		}

		let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
		scaleAnimation.fromValue = 1
		scaleAnimation.toValue = 1.15
		scaleAnimation.damping = 0.1
		scaleAnimation.initialVelocity = 0.5

		let rotationAnimation = CASpringAnimation(keyPath: "transform.rotation.z")
		rotationAnimation.fromValue = 0
		rotationAnimation.byValue = (iterationCount % 2 == 0 ? 1 : -1) * (Double.pi / 8)
		rotationAnimation.damping = 0.1
		rotationAnimation.initialVelocity = 10

		let yellingAnimationGroup = CAAnimationGroup()
		yellingAnimationGroup.duration = 0.3
		yellingAnimationGroup.autoreverses = true
		yellingAnimationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		yellingAnimationGroup.animations = [scaleAnimation, rotationAnimation]

		gooseView.layer.add(yellingAnimationGroup, forKey: "animation")

		CATransaction.commit()
	}
}
