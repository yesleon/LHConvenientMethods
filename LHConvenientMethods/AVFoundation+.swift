//
//  AVFoundation+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/27.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import AVFoundation
import UIKit

extension AVCaptureDevice {
    public static func defaultCamera(position: Position) throws -> AVCaptureDevice {
        guard let device = `default`(.builtInWideAngleCamera, for: .video, position: position) else { throw Error.cannotFindDevice }
        return device
    }
    public enum Error: Swift.Error {
        case cannotFindDevice
    }
}

extension AVCaptureSession {
    
    public enum Error: Swift.Error {
        case cannotAddInput, cannotAddOutput
    }
    
    public func configure(configureHandler: (AVCaptureSession) throws -> Void) rethrows {
        beginConfiguration()
        try configureHandler(self)
        commitConfiguration()
    }
    
    public func setInputVideoDevice(_ device: AVCaptureDevice) throws {
        let videoDeviceInput = try AVCaptureDeviceInput(device: device)
        guard canAddInput(videoDeviceInput) else { throw Error.cannotAddInput }
        addInput(videoDeviceInput)
    }
    
    public func setOutput(_ output: AVCaptureOutput) throws {
        guard canAddOutput(output) else { throw Error.cannotAddOutput }
        addOutput(output)
    }
    
}

extension AVCaptureVideoOrientation {
    
    public init?(_ deviceOrientation: UIDeviceOrientation) {
        let rawValue = UIDevice.current.orientation.rawValue
        if rawValue >= 1, rawValue <= 4 {
            self.init(rawValue: rawValue)
        } else {
            return nil
        }
    }
    
}
