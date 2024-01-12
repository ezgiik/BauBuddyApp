//
//  QRScanner.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 9.01.2024.
//

import UIKit
import AVFoundation

class QRScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var searchBar: UISearchBar?
    var qrCodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanner()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScanning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanning()
    }

    func setupScanner() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession = AVCaptureSession()
            
            if let session = captureSession, session.canAddInput(videoInput) {
                session.addInput(videoInput)
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: session)
                    if let previewLayer = previewLayer {
                        previewLayer.frame = view.layer.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        view.layer.addSublayer(previewLayer)
                        
                        
                        if let qrCodeFrameView = qrCodeFrameView {
                            view.addSubview(qrCodeFrameView)
                            view.bringSubviewToFront(qrCodeFrameView)
                        }
                        
                        startScanning()
                    }
                } else {
                    failed()
                }
            } else {
                failed()
            }
        } catch {
            failed()
        }
    }
    
    func setupUI() {
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
            qrCodeFrameView.isHidden = true
        }
    }
    
    func startScanning() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
    }
    
    func failed() {
        let alert = UIAlertController(title: "Scanning Not Supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let tabBarController = tabBarController,
           let taskListView = tabBarController.viewControllers?[0] as? TaskListView {
            
            
            if let searchBar = taskListView.searchBar {
                self.searchBar = searchBar
                self.searchBar?.text = metadataObject.stringValue
                taskListView.searchBar(self.searchBar!, textDidChange: metadataObject.stringValue ?? "")
                tabBarController.selectedIndex = 0
                
                tabBarController.tabBar.isHidden = false
                
                
                if let qrCodeFrameView = qrCodeFrameView {
                    let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObject)
                    
                    if let bounds = barCodeObject?.bounds {
                        qrCodeFrameView.frame = bounds
                        qrCodeFrameView.isHidden = false
                    }
                }
            }
        }
    }
}
