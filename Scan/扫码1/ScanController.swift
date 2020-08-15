//
//  ScanController.swift
//  GaoPei
//
//  Created by iscopy on 2020/6/16.
//  Copyright © 2020 xolo. All rights reserved.
//

import UIKit
import AVFoundation

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
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
    //设置除了扫描区以外的视图
    //半径
    let radius:Float = 150
    //偏移
    let deviation:Float = 50
    //边框
    let frames:Float = 3
    //边框长度
    let frameLong:Float = 10
    func setView(){
        let topTime = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
        topTime.backgroundColor = UIColor.white
        self.view.addSubview(topTime)
        
        //框框
        let colorOuterFrame:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        let leftView = UIView(frame: CGRect(x: 0, y: 20, width: screenWidth/2-CGFloat(self.radius), height: screenHeight))
        leftView.backgroundColor = colorOuterFrame
        self.view.addSubview(leftView)
        let rightView = UIView(frame: CGRect(x: screenWidth/2+CGFloat(self.radius), y: 20, width: screenWidth/2-CGFloat(self.radius), height: screenHeight))
        rightView.backgroundColor = colorOuterFrame
        self.view.addSubview(rightView)
        let topView = UIView(frame: CGRect(x: screenWidth/2-CGFloat(self.radius), y: 20, width: CGFloat(self.radius)*2, height: screenHeight/2 - CGFloat(self.radius) - CGFloat(self.deviation) - 20))
        topView.backgroundColor = colorOuterFrame
        self.view.addSubview(topView)
        let bottomView = UIView(frame: CGRect(x: screenWidth/2-CGFloat(self.radius), y: screenHeight/2 + CGFloat(self.radius) - CGFloat(self.deviation), width: CGFloat(self.radius)*2, height: screenHeight/2-CGFloat(self.radius) + CGFloat(self.deviation)))
        bottomView.backgroundColor = colorOuterFrame
        self.view.addSubview(bottomView)
        
        
        //边框
        let colorFrame:UIColor = UIColor(red: 240, green: 248, blue: 255, alpha: 1)
        //左上
        let leftTopLeftx = screenWidth/2 - CGFloat(self.radius)
        let leftTopLefty = screenHeight/2 - CGFloat(self.radius) - CGFloat(self.deviation) - CGFloat(self.frames)
        let leftTopLeft = UIView(frame: CGRect(x: leftTopLeftx, y: leftTopLefty, width:  CGFloat(self.frameLong) - CGFloat(self.frames), height:  CGFloat(self.frames)))
        leftTopLeft.backgroundColor = colorFrame
        self.view.addSubview(leftTopLeft)
        let leftTopTopx = screenWidth/2 - CGFloat(self.radius) - CGFloat(self.frames)
        let leftTopTopy = screenHeight/2 - CGFloat(self.radius) - CGFloat(self.deviation) - CGFloat(self.frames)
        let leftTopTop = UIView(frame: CGRect(x: leftTopTopx, y: leftTopTopy, width:  CGFloat(self.frames), height:  CGFloat(self.frameLong)))
        leftTopTop.backgroundColor = colorFrame
        self.view.addSubview(leftTopTop)
        //右上
        let rightTopRightx = screenWidth/2 + CGFloat(self.radius)
        let rightTopRighty = screenHeight/2 - CGFloat(self.radius) - CGFloat(self.deviation)
        let rightTopRight = UIView(frame: CGRect(x: rightTopRightx, y: rightTopRighty, width:   CGFloat(self.frames), height:  CGFloat(self.frameLong) - CGFloat(self.frames)))
        rightTopRight.backgroundColor = colorFrame
        self.view.addSubview(rightTopRight)
        let rightTopTopx = screenWidth/2 + CGFloat(self.radius) - CGFloat(self.frameLong) + CGFloat(self.frames)
        let rightTopTopy = screenHeight/2 - CGFloat(self.radius) - CGFloat(self.deviation) - CGFloat(self.frames)
        let rightTopTop = UIView(frame: CGRect(
            x: rightTopTopx,
            y: rightTopTopy,
            width:  CGFloat(self.frameLong),
            height:  CGFloat(self.frames)))
        rightTopTop.backgroundColor = colorFrame
        self.view.addSubview(rightTopTop)
        //左下
        let leftBottomLeftx = screenWidth/2 - CGFloat(self.radius) - CGFloat(self.frames)
        let leftBottomLefty1 = screenHeight/2 + CGFloat(self.radius) - CGFloat(self.deviation)
        let leftBottomLefty = leftBottomLefty1 + CGFloat(self.frames) - CGFloat(self.frameLong)
        let leftBottomLeft = UIView(frame: CGRect(x: leftBottomLeftx, y: leftBottomLefty, width:  CGFloat(self.frames), height:  CGFloat(self.frameLong)))
        leftBottomLeft.backgroundColor = colorFrame
        self.view.addSubview(leftBottomLeft)
        let leftBottomBottomx = screenWidth/2 - CGFloat(self.radius)
        let leftBottomBottomy = screenHeight/2 + CGFloat(self.radius) - CGFloat(self.deviation)
        let leftBottomBottom = UIView(frame: CGRect(x: leftBottomBottomx, y: leftBottomBottomy, width:  CGFloat(self.frameLong) - CGFloat(self.frames), height:  CGFloat(self.frames)))
        leftBottomBottom.backgroundColor = colorFrame
        self.view.addSubview(leftBottomBottom)
        //右下
        let rightBottomRightx = screenWidth/2 + CGFloat(self.radius)
        let rightBottomRighty1 = screenHeight/2 + CGFloat(self.radius)
        let rightBottomRighty = rightBottomRighty1 - CGFloat(self.deviation) - CGFloat(self.frameLong) + CGFloat(self.frames)
        let rightBottomRight = UIView(frame: CGRect(x: rightBottomRightx, y: rightBottomRighty, width:  CGFloat(self.frames), height:  CGFloat(self.frameLong)))
        rightBottomRight.backgroundColor = colorFrame
        self.view.addSubview(rightBottomRight)
        let rightBottomBottomx = screenWidth/2 + CGFloat(self.radius) - CGFloat(self.frameLong) + CGFloat(self.frames)
        let rightBottomBottomy = screenHeight/2 + CGFloat(self.radius) - CGFloat(self.deviation)
        let rightBottomBottom = UIView(frame: CGRect(x: rightBottomBottomx, y: rightBottomBottomy, width:  CGFloat(self.frameLong) - CGFloat(self.frames), height:  CGFloat(self.frames)))
        rightBottomBottom.backgroundColor = colorFrame
        self.view.addSubview(rightBottomBottom)
        
        // button  点击无参数
        let button = UIButton(frame: CGRect(x: 20, y: 50, width: 50, height: 30))
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

    //设置相机
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
            //output.rectOfInterest = CGRect(x: CGFloat(self.radius)/screenHeight, y: (screenWidth/2-CGFloat(self.radius))/screenWidth, width: (CGFloat(self.radius) + CGFloat(self.deviation))/screenHeight, height: (CGFloat(self.radius) + CGFloat(self.deviation))/screenWidth)
            output.rectOfInterest = CGRect(
                x: (screenHeight/2 - CGFloat(self.radius) - CGFloat(self.deviation))/screenHeight,
                y: (screenWidth/2 - CGFloat(self.radius))/screenWidth,
                width: CGFloat(self.radius)*2/screenHeight,
                height: CGFloat(self.radius)*2/screenWidth)
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
            self.sendScans!(self.intercepts(str), type ?? "0000")
        }
    }
    
    //MARK:- 截取
    func intercepts(_ code:String) -> String {
        var codes = code
        if codes.contains("http"){
            if codes.contains("c="){
                let jie = codes.count - Strings.positionOf(code: codes, sub: "c=", backwards:true) - 2
                codes = String(codes.suffix(jie))
            }else{
                if codes.contains("c?"){
                    let jie = codes.count - Strings.positionOf(code: codes, sub: "c?", backwards:true) - 2
                    codes = String(codes.suffix(jie))
                }
            }
        }
        return codes
    }

    
}
