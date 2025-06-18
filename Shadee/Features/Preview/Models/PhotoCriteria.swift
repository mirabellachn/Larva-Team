//
//  PhotoCriteria.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

struct PhotoCriteria {
    var isFacingCamera: Bool = false
    var isOnlyOneFaceDetected: Bool = false
    var isCaptureQualityGood: Bool = false

    func isValid() -> Bool {
        return isFacingCamera && isOnlyOneFaceDetected && isCaptureQualityGood
    }
}
