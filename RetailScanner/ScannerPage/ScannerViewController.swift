//
//  ScannerViewController.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 21/12/24.
//

import UIKit
import AVFoundation
import AudioToolbox


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    var payload: [String: Any]? 
    let viewModel = ScannerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Retail Scanner"
        
        if let payload = payload {
            viewModel.fetchData(payload: payload)
        }
        startVideoCapture()
        var midX = CGRectGetMidX(self.view.bounds)/2
        var midY = CGRectGetMidY(self.view.bounds)
        codeFrame.frame = CGRect(x: midX, y: midY, width: midX*2, height: 4)
        view.addSubview(codeFrame)
    }
    

    
    public func startVideoCapture() {
        
        // Do any additional setup after loading the view, typically from a nib.
        
        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {
        
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType
                
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
                
            } catch {
                print("Error Device Input")
            }
            
        }
        
    }
    
    let codeLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    let codeFrame: UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.red.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let stringCodeValue = metadataObject.stringValue else { return }
        

        
        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }

        // Play system sound with custom mp3 file
        if let customSoundUrl = Bundle.main.url(forResource: "beep-07", withExtension: "mp3") {
            var customSoundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &customSoundId)
            //let systemSoundId: SystemSoundID = 1016  // to play apple's built in sound, no need for upper 3 lines
            
            AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
                AudioServicesDisposeSystemSoundID(customSoundId)
            }, nil)
            
            AudioServicesPlaySystemSound(customSoundId)
        }
        captureSession?.stopRunning()
        // Stop capturing and hence stop executing metadataOutput function over and over again
        
        if !viewModel.authenticityBarcode(barcodedata: stringCodeValue) {
            let alert = UIAlertController(title: "barcode \(stringCodeValue)", message: "Is not proper barcode, please choose another", preferredStyle: UIAlertController.Style.alert)
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
                // your code with delay
                alert.dismiss(animated: true, completion: { [weak self] in
                    self?.captureSession?.startRunning()
                })}
        }
        

        // Call the function which performs navigation and pass the code string value we just detected
        if viewModel.entryPoint == RetailConstants.fromInventory {
            let overlayNavigation = self.storyboard?.instantiateViewController(withIdentifier: "overlayViewController") as! overlayViewController
            overlayNavigation.barcodeValue = stringCodeValue
            overlayNavigation.delegate = self
            overlayNavigation.modalPresentationStyle = .overCurrentContext
            self.present(overlayNavigation, animated: true)
        
        } else {
            
            if viewModel.duplicateBarcodeCheck(barcodeData: stringCodeValue) {
                let alert = UIAlertController(title: "barcode \(stringCodeValue)", message: "already added in retail bill", preferredStyle: UIAlertController.Style.alert)
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // your code with delay
                    alert.dismiss(animated: true, completion: { [weak self] in
                        self?.captureSession?.startRunning()
                    })}

                
            } else if viewModel.barcodeReliabilityCheck(barcodeData: stringCodeValue) {
                let alert = UIAlertController(title: "barcode \(stringCodeValue)", message: "added successfully", preferredStyle: UIAlertController.Style.alert)
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // your code with delay
                    alert.dismiss(animated: true, completion: { [weak self] in
                        self?.captureSession?.startRunning()
                    })}
            } else {
                let alert = UIAlertController(title: "Barcode \(stringCodeValue)", message: "Not Found in Inventory, Please add the inventory First", preferredStyle: UIAlertController.Style.alert)
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // your code with delay
                    alert.dismiss(animated: true, completion: { [weak self] in
                        self?.captureSession?.startRunning()
                    })}
            }
            
        }
            
    }
}


extension ScannerViewController: ovelayDelegate {
    func triggerAV() {
        captureSession?.startRunning()
    }
    
    
}
