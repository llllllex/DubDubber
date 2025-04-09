//
//  Data+Extensions.swift
//  Fancer
//
//  Created by Lex on 3/21/25.
//

import Foundation
import ImageIO

enum ImageFormat {
    
    /// The format cannot be recognized or not supported yet.
    case unknown
    /// PNG image format.
    case PNG
    /// JPEG image format.
    case JPEG
    /// GIF image format.
    case GIF
    
    case TIFF
    
    struct HeaderData {
        static let PNG: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        static let JPEG_SOI: [UInt8] = [0xFF, 0xD8]
        static let JPEG_IF: [UInt8] = [0xFF]
        static let GIF: [UInt8] = [0x47, 0x49, 0x46]
        
        static let TIFF_A: [UInt8] = [0x42, 0x49, 0x4D, 0x00]
        static let TIFF_B: [UInt8] = [0x49, 0x49, 0x2A, 0x00]
        static let TIFF_C: [UInt8] = [0x4D, 0x4D, 0x00, 0x2A]
    }
    
    /// https://en.wikipedia.org/wiki/JPEG
    enum JPEGMarker {
        case SOF0           //baseline
        case SOF2           //progressive
        case DHT            //Huffman Table
        case DQT            //Quantization Table
        case DRI            //Restart Interval
        case SOS            //Start Of Scan
        case RSTn(UInt8)    //Restart
        case APPn           //Application-specific
        case COM            //Comment
        case EOI            //End Of Image
        
        var bytes: [UInt8] {
            switch self {
            case .SOF0:         return [0xFF, 0xC0]
            case .SOF2:         return [0xFF, 0xC2]
            case .DHT:          return [0xFF, 0xC4]
            case .DQT:          return [0xFF, 0xDB]
            case .DRI:          return [0xFF, 0xDD]
            case .SOS:          return [0xFF, 0xDA]
            case .RSTn(let n):  return [0xFF, 0xD0 + n]
            case .APPn:         return [0xFF, 0xE0]
            case .COM:          return [0xFF, 0xFE]
            case .EOI:          return [0xFF, 0xD9]
            }
        }
    }
}

extension Data {
    
    /// Gets the image format corresponding to the data.
    var imageFormat: ImageFormat {
        guard self.count > 8 else { return .unknown }
        
        var buffer = [UInt8](repeating: 0, count: 8)
        self.copyBytes(to: &buffer, count: 8)
        
        if buffer == ImageFormat.HeaderData.PNG {
            return .PNG
            
        } else if buffer[0] == ImageFormat.HeaderData.JPEG_SOI[0],
            buffer[1] == ImageFormat.HeaderData.JPEG_SOI[1],
            buffer[2] == ImageFormat.HeaderData.JPEG_IF[0]
        {
            return .JPEG
            
        } else if buffer[0] == ImageFormat.HeaderData.GIF[0],
            buffer[1] == ImageFormat.HeaderData.GIF[1],
            buffer[2] == ImageFormat.HeaderData.GIF[2]
        {
            return .GIF
            
        } else if buffer[0] == ImageFormat.HeaderData.TIFF_A[0],
                  buffer[1] == ImageFormat.HeaderData.TIFF_A[1],
                  buffer[2] == ImageFormat.HeaderData.TIFF_A[2] {
            
            return .TIFF
            
        } else if buffer[0] == ImageFormat.HeaderData.TIFF_B[0],
                 buffer[1] == ImageFormat.HeaderData.TIFF_B[1],
                 buffer[2] == ImageFormat.HeaderData.TIFF_B[2] {
           
           return .TIFF
           
       } else if buffer[0] == ImageFormat.HeaderData.TIFF_C[0],
                 buffer[1] == ImageFormat.HeaderData.TIFF_C[1],
                 buffer[2] == ImageFormat.HeaderData.TIFF_C[2] {
           
           return .TIFF
       }
        
        return .unknown
    }
    
    func contains(jpeg marker: ImageFormat.JPEGMarker) -> Bool {
        guard imageFormat == .JPEG else {
            return false
        }
        
        let bytes = [UInt8](self)
        let markerBytes = marker.bytes
        for (index, item) in bytes.enumerated() where bytes.count > index + 1 {
            guard
                item == markerBytes.first,
                bytes[index + 1] == markerBytes[1] else {
                continue
            }
            return true
        }
        return false
    }
}
