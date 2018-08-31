//
//  CameraController.swift
//  Victagram
//
//  Created by Victor Chang on 29/08/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate{
	
	let dismissButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
		return button
	}()
	
	let capturePhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
		
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		transitioningDelegate = self
		
		setupCaptureSession()
		setupHUD()
		
	}
	
	let customAnimationPresenter = CustomAnimationPresenter()
	let customAnimationDismisser = CustomAnimationDismisser()
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		return customAnimationPresenter
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		return customAnimationDismisser
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}

	fileprivate func setupHUD() {
		
		view.addSubview(capturePhotoButton)
		capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
		capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
		view.addSubview(dismissButton)
		dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
		
	}
	
	@objc fileprivate func handleDismiss() {
		print("Dismissing Camera...")
		dismiss(animated: true, completion: nil)
		
	}
	
	@objc fileprivate func handleCapturePhoto() {
		print("Capturing Photo...")
		
		let settings = AVCapturePhotoSettings()
//		settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
		guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
		settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
 
		output.capturePhoto(with: settings, delegate: self)
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		
		guard let imageData = photo.fileDataRepresentation() else { return }
		
		let previewImage = UIImage(data: imageData)
		
		let containerView = PreviewPhotoContainerView()
		containerView.previewImageView.image = previewImage
		view.addSubview(containerView)
		containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
//		let previewImageView = UIImageView(image: previewImage)
//		view.addSubview(previewImageView)
//		previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//		print("Finish processing sample buffer...")
	}

	let output = AVCapturePhotoOutput()

	fileprivate func setupCaptureSession() {
		
		// 1. Setup inputs
		let captureSession = AVCaptureSession()
		
		guard let captureDevice =  AVCaptureDevice.default(for: AVMediaType.video) else { return }
		
		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			if captureSession.canAddInput(input) {
				captureSession.addInput(input)
			}
		} catch let error {
			print("Couldn't set up camera input: ", error)
		}
		
		// 2. Setup Outputs
		if captureSession.canAddOutput(output) {
			captureSession.addOutput(output)
		}
		
		// 3. Setup Output Preview
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.frame
		previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		
		view.layer.addSublayer(previewLayer)
		
		captureSession.startRunning()
	}
	
}
