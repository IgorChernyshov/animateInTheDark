//
//  ViewController.swift
//  animateInTheDark
//
//  Created by Igor Chernyshov on 26.11.2021.
//

import UIKit

class ViewController: UIViewController {

	var squareView: UIView = UIView()
	var startButton: UIBarButtonItem?

	var squareAnimator: UIViewPropertyAnimator?
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
		guard isAnimating else {
			squareAnimator?.stopAnimation(true)
			return
		}
		animateSquare()
	}

	private func configureStartButtonImage() {
		startButton?.image = isAnimating ? UIImage(systemName: "stop.circle") : UIImage(systemName: "play.circle")
	}

	private func animateSquare() {
		squareAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut) {
			UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseInOut]) {
				let translationY = self.iterationCount % 2 == 0 ? self.view.frame.midY - self.squareSide : 0
				self.squareView.transform = CGAffineTransform(translationX: 0, y: translationY)

				let cornerRadius = self.iterationCount % 2 == 0 ? self.squareSide * 0.5 : 0
				self.squareView.layer.cornerRadius = cornerRadius

				let backgroundColor = self.colors[(self.iterationCount + 1) % self.colors.count]
				self.squareView.backgroundColor = backgroundColor
			} completion: { didFinish in
				if didFinish {
					self.iterationCount += 1
					self.animateSquare()
				} else {
					self.iterationCount = 0
					UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseInOut]) {
						self.squareView.transform = .identity
						self.squareView.layer.cornerRadius = 0
						self.squareView.backgroundColor = self.colors.first
					}
				}
			}
		}
		squareAnimator?.startAnimation()
	}
}
