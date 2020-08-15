//
//  Scan2Controller.swift
//  Scan
//
//  Created by iscopy on 2020/7/15.
//  Copyright © 2020 iscopy. All rights reserved.
//

import UIKit
import AVFoundation

class Scan2Controller: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var session:AVCaptureSession!
    var screenWidth : CGFloat!
    var screenHeight:CGFloat!
    
    //创建一个闭包属性
    var sendScans : sendScan?
    //属性传值
    var type : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        setView()
        setCamera()
    }
    //MARK: - 设置除了扫描区以外的视图
    func setView(){
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth/2-100, height: screenHeight))
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(leftView)
        let rightView = UIView(frame: CGRect(x: screenWidth/2+100, y: 0, width: screenWidth/2-100, height: screenHeight))
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(rightView)
        let topView = UIView(frame: CGRect(x: screenWidth/2-100, y: 0, width: 200, height: 200))
        
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        self.view.addSubview(topView)
        let bottomView = UIView(frame: CGRect(x: screenWidth/2-100, y: 400, width: 200, height: screenHeight-300))
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(bottomView)
        
        // button  点击无参数
        let button = UIButton(frame: CGRect(x: 20, y: 40, width: 50, height: 30))
        button.backgroundColor = UIColor.blue
        button.setTitle("返回", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(ScanController.buttonTap), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
    }
    
    //selector 其实是 Objective-C runtime 的概念
    @objc func buttonTap() {
        print("buttonTap")
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion:nil)
    }
    
    //MARK: - 设置相机扫描范围
    func setCamera(){
        
        //获取摄像设备
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        do {
            //创建输入流
            let input =  try AVCaptureDeviceInput(device: device)
            //创建输出流
            let output = AVCaptureMetadataOutput()
            //设置会话
            session = AVCaptureSession()
            //连接输入输出
            if session.canAddInput(input){
                session.addInput(input)
            }
            
            if session.canAddOutput(output){
                session.addOutput(output)
                //设置输出流代理，从接收端收到的所有元数据都会被传送到delegate方法，所有delegate方法均在queue中执行
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                //设置扫描二维码类型
                output.metadataObjectTypes = [ AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,
                                               AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.code128,
                                               AVMetadataObject.ObjectType.code39,AVMetadataObject.ObjectType.code93]
                //扫描区域
                //rectOfInterest 属性中x和y互换，width和height互换。
                output.rectOfInterest = CGRect(x: 200/screenHeight, y: (screenWidth/2-100)/screenWidth, width: 200/screenHeight, height: 200/screenWidth)
            }
            //捕捉图层
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = self.view.layer.bounds
            self.view.layer.insertSublayer(previewLayer, at: 0)
            //持续对焦
            if device.isFocusModeSupported(.continuousAutoFocus){
                try  input.device.lockForConfiguration()
                input.device.focusMode = .continuousAutoFocus
                input.device.unlockForConfiguration()
            }
            session.startRunning()
        } catch  {
        }
    }
    
    //扫描完成的代理
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session?.stopRunning()
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            let str = readableObject.stringValue!
            
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion:nil)
            //将值附在闭包上,传到First页面
            self.sendScans!(str, type ?? "0000")
        }
    }
    
}
