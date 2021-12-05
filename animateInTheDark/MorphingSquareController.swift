//
//  MorphingSquareController.swift
//  animateInTheDark
//
//  Created by Igor Chernyshov on 26.11.2021.
//

import UIKit

class MorphingSquareController: UIViewController {

	var squareView: UIView = UIView()
	var startButton: UIBarButtonItem?

	var iterationCount = 0
	var isAnimating = false

	let colors: [UIColor] = [.darkGray, .systemYellow, .systemMint, .systemRed, .systemCyan, .systemPink, .systemOrange]
	let squareSide = 100.0
	let animationDuration = 0.8

	override func viewDidLoad() {
		super.viewDidLoad()
		startButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(didTapStart))
		startButton?.tintColor = .darkGray
		configureStartButtonImage()
		navigationItem.leftBarButtonItem = startButton
		squareView = UIView(frame: CGRect(x: view.frame.midX - squareSide * 0.5, y: view.frame.midY - squareSide * 0.5, width: squareSide, height: squareSide))
		squareView.layer.masksToBounds = true
		squareView.backgroundColor = colors.first
		view.addSubview(squareView)
		view.backgroundColor = .white
	}

	@objc private func didTapStart() {
		isAnimating.toggle()
		configureStartButtonImage()
		guard isAnimating else { return CATransaction.flush() }
		animateSquare()
	}

	private func configureStartButtonImage() {
		startButton?.image = isAnimating ? UIImage(systemName: "stop.circle") : UIImage(systemName: "play.circle")
	}

	private func animateSquare() {
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			guard self.isAnimating else { return }
			self.iterationCount += 1
			self.animateSquare()
		}

		let animationGroup = CAAnimationGroup()

		let translationAnimation = CABasicAnimation(keyPath: "transform.translation.y")
		translationAnimation.fromValue = 0
		translationAnimation.toValue = view.frame.midY - squareSide

		let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
		cornerRadiusAnimation.fromValue = 0
		cornerRadiusAnimation.toValue = squareSide * 0.5

		let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
		backgroundColorAnimation.fromValue = colors.first?.cgColor
		backgroundColorAnimation.toValue = colors[(iterationCount + 1) % colors.count].cgColor

		let bounceAnimation = CABasicAnimation(keyPath: "transform.scale.y")
		bounceAnimation.fromValue = 1.0
		bounceAnimation.toValue = 0.1
		bounceAnimation.beginTime = animationDuration * 0.9

		animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		animationGroup.duration = animationDuration
		animationGroup.autoreverses = true
		animationGroup.animations = [translationAnimation, cornerRadiusAnimation, backgroundColorAnimation, bounceAnimation]

		squareView.layer.add(animationGroup, forKey: nil)

		CATransaction.commit()
	}
}
