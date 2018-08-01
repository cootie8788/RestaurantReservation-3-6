//
//  QRCodeViewController.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/27.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var alertController: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得後置鏡頭
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // 開始影片擷取
            captureSession.startRunning()
        } catch {
            print(error)
            return
        }
        
        // 初始化ＱＲ ＣＯＤＥ框
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            
            qrCodeFrameView.layer.borderWidth = 2
            
            view.addSubview(qrCodeFrameView)
            
            view.bringSubview(toFront: qrCodeFrameView)
            
        }
    }
    
    // 辨識到qrCode時會跑這
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if let metaObj = metadataObj.stringValue {
                UserDefaults.standard.set(metaObj, forKey: MemberKey.TableNumber.rawValue)
                if alertController == nil {
                alertController = UIAlertController(title: "桌號", message: "第\(metaObj)桌", preferredStyle: .alert)
                let action = UIAlertAction(title: "確定", style: .default) { (action) in
//                    let controller = self.tabBarController?.viewControllers?.first as? UINavigationController
//                    self.present(controller!, animated: true, completion: nil)
                    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "OrderMenu") as? UINavigationController else {
                        return
                    }
                    controller.modalPresentationStyle = .currentContext
                    self.present(controller, animated: true)
//                    self.tabBarController?.selectedIndex = 1
                }
                alertController!.addAction(action)
                present(alertController!, animated: true, completion: nil)
                }
            }
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
