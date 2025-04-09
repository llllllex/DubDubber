//
//  Haptic.swift
//  Fancer
//
//  Created by Lex on 3/22/25.
//

import Foundation
import SwiftUI
import CoreHaptics

#if canImport(UIKit)
import UIKit

@MainActor
public final class Haptic {
    
    public static let shared = Haptic()
    private init() {
        prepareHaptics()
        generatePlayers()
    }
    
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator? = nil
    private let notificationFeedbackGenerator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    private var hapticEngine: CHHapticEngine?
    
    //MARK: Different Player
    
    private var scrollingHapticPlayer: CHHapticPatternPlayer?
    
    private var glassTouchDownPlayer: CHHapticPatternPlayer?
    
    private var glassTouchUpPlayer: CHHapticPatternPlayer?
}


//MARK: - Private

private extension Haptic {
    
    func prepareHaptics() {
        // 检查设备是否支持触觉反馈
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            // 初始化触觉引擎
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("[Haptic Engine]: 触觉引擎启动失败: \(error.localizedDescription)")
        }
    }
    
    func generatePlayers() {
        generateScrollingPlayer()
        
//        let glassTouchDownPattern = createPatternFromAHAP("glassTouchDown")!
//        glassTouchDownPlayer = try? hapticEngine?.makePlayer(with: glassTouchDownPattern)
//        
//        let glassTouchUpPattern = createPatternFromAHAP("glassTouchUp")!
//        glassTouchUpPlayer = try? hapticEngine?.makePlayer(with: glassTouchUpPattern)
        
        generateGlassTouchDownPlayer()
        generateGlassTouchUpPlayer()
    }
    
    func generateScrollingPlayer() {
        guard let hapticEngine = hapticEngine else { return }
        guard scrollingHapticPlayer == nil else { return }
        
        // 1. 触觉强度（Intensity）：调高到 0.6，使反馈更明显、更有冲击感
        let intensity = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 0.5
        )
        // 2. 触觉锋利度（Sharpness）：保持最大值 1.0，确保触感尖锐、清脆
        let sharpness = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 1
        )
        // 3. 起始时间（Attack Time）：设为 0.0，代表反馈瞬间达到最大强度，没有渐入效果
        let attackTime = CHHapticEventParameter(
            parameterID: .attackTime,
            value: 0.0
        )
        // 4. 衰减时间（Decay Time）：设为 0.0，反馈在达到顶点后立即结束，不会拖延
        let decayTime = CHHapticEventParameter(
            parameterID: .decayTime,
            value: 0.0
        )
        // 5. 持续时间（Sustained）：设为 0.0，不保持额外的持续反馈，确保反馈短促
        let sustained = CHHapticEventParameter(
            parameterID: .sustained,
            value: 0.0
        )
        // 6. 释放时间（Release Time）：设为 0.0，反馈结束时瞬间停止，没有缓慢释放
        let releaseTime = CHHapticEventParameter(
            parameterID: .releaseTime,
            value: 0.0
        )
        
        // 创建触觉事件（短促类型）
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                intensity,
                sharpness,
                attackTime,
                decayTime,
                sustained,
                releaseTime
            ],
            relativeTime: 0
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            scrollingHapticPlayer = try hapticEngine.makePlayer(with: pattern)
            // try scrollingHapticPlayer?.start(atTime: 0)
        } catch {
            print("[Haptic Engine]: 播放触觉反馈失败: \(error.localizedDescription)")
        }
    }
    
    
    func generateGlassTouchDownPlayer() {
        guard let hapticEngine = hapticEngine else { return }
        guard glassTouchDownPlayer == nil else { return }
        
        // 1. 触觉强度（Intensity）：调高到 0.6，使反馈更明显、更有冲击感
        let intensity = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 0.5
        )
        // 2. 触觉锋利度（Sharpness）：保持最大值 1.0，确保触感尖锐、清脆
        let sharpness = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 1
        )
        // 3. 起始时间（Attack Time）：设为 0.0，代表反馈瞬间达到最大强度，没有渐入效果
        let attackTime = CHHapticEventParameter(
            parameterID: .attackTime,
            value: 0.0
        )
        // 4. 衰减时间（Decay Time）：设为 0.0，反馈在达到顶点后立即结束，不会拖延
        let decayTime = CHHapticEventParameter(
            parameterID: .decayTime,
            value: 0.0
        )
        // 5. 持续时间（Sustained）：设为 0.0，不保持额外的持续反馈，确保反馈短促
        let sustained = CHHapticEventParameter(
            parameterID: .sustained,
            value: 0.0
        )
        // 6. 释放时间（Release Time）：设为 0.0，反馈结束时瞬间停止，没有缓慢释放
        let releaseTime = CHHapticEventParameter(
            parameterID: .releaseTime,
            value: 0.0
        )
        
        // 创建触觉事件（短促类型）
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                intensity,
                sharpness,
                attackTime,
                decayTime,
                sustained,
                releaseTime
            ],
            relativeTime: 0
        )
        
        
        var audioEvent: CHHapticEvent? = nil
        
        if let audioID = registerAudioResources("glassTouchDown") {
            
            audioEvent = CHHapticEvent(
                audioResourceID: audioID,
                parameters: [CHHapticEventParameter(parameterID: .audioVolume, value: 1.0),],
                relativeTime: 0.0
            )
        }
        
        var events = [event]
        if let audioEvent {
            events.append(audioEvent)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            glassTouchDownPlayer = try hapticEngine.makePlayer(with: pattern)
            // try scrollingHapticPlayer?.start(atTime: 0)
        } catch {
            print("[Haptic Engine]: 播放触觉反馈失败: \(error.localizedDescription)")
        }
    }
    
    
    func generateGlassTouchUpPlayer() {
        guard let hapticEngine = hapticEngine else { return }
        guard glassTouchUpPlayer == nil else { return }
        
        // 1. 触觉强度（Intensity）：调高到 0.6，使反馈更明显、更有冲击感
        let intensity = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 0.5
        )
        // 2. 触觉锋利度（Sharpness）：保持最大值 1.0，确保触感尖锐、清脆
        let sharpness = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 1
        )
        // 3. 起始时间（Attack Time）：设为 0.0，代表反馈瞬间达到最大强度，没有渐入效果
        let attackTime = CHHapticEventParameter(
            parameterID: .attackTime,
            value: 0.0
        )
        // 4. 衰减时间（Decay Time）：设为 0.0，反馈在达到顶点后立即结束，不会拖延
        let decayTime = CHHapticEventParameter(
            parameterID: .decayTime,
            value: 0.0
        )
        // 5. 持续时间（Sustained）：设为 0.0，不保持额外的持续反馈，确保反馈短促
        let sustained = CHHapticEventParameter(
            parameterID: .sustained,
            value: 0.0
        )
        // 6. 释放时间（Release Time）：设为 0.0，反馈结束时瞬间停止，没有缓慢释放
        let releaseTime = CHHapticEventParameter(
            parameterID: .releaseTime,
            value: 0.0
        )
        
        // 创建触觉事件（短促类型）
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                intensity,
                sharpness,
                attackTime,
                decayTime,
                sustained,
                releaseTime
            ],
            relativeTime: 0
        )
        
        var audioEvent: CHHapticEvent? = nil
        
        if let audioID = registerAudioResources("glassTouchUp") {
            
            audioEvent = CHHapticEvent(
                audioResourceID: audioID,
                parameters: [CHHapticEventParameter(parameterID: .audioVolume, value: 1.0),],
                relativeTime: 0.0
            )
        }
        
        var events = [event]
        if let audioEvent {
            events.append(audioEvent)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            glassTouchUpPlayer = try hapticEngine.makePlayer(with: pattern)
            // try scrollingHapticPlayer?.start(atTime: 0)
        } catch {
            print("[Haptic Engine]: 播放触觉反馈失败: \(error.localizedDescription)")
        }
    }
}


//MARK: - Life Cycle

public extension Haptic {
    
    func didBecomeActive() {
        do {
            try hapticEngine?.start()
        } catch {
            print("[Haptic Engine]: 触觉引擎启动失败: \(error.localizedDescription)")
        }
    }
    
    func didEnterBackground() {
        hapticEngine?.stop(completionHandler: { error in
            if let error = error {
                print("[Haptic Engine]: 触觉引擎停止失败: \(error.localizedDescription)")
            }
        })
    }
}


//MARK: - Selection Feedback

public extension Haptic {
    
    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        self.notificationFeedbackGenerator.notificationOccurred(type)
    }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    func startSelection() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
    }

    func selectionChanged() {
        
        if selectionFeedbackGenerator == nil {
            selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        }
        
        selectionFeedbackGenerator?.prepare()
        selectionFeedbackGenerator?.selectionChanged()
        selectionFeedbackGenerator?.prepare()
    }
    
    func stopSelection() {
        selectionFeedbackGenerator = nil
    }
    
    func glassTouchDown() {
        try? glassTouchDownPlayer?.start(atTime: 0)
    }
    
    func glassTouchUp() {
        try? glassTouchUpPlayer?.start(atTime: 0)
    }
}

extension Haptic {
    
    private func registerAudioResources(_ filename: String) -> CHHapticAudioResourceID? {
        guard let audioURL = Bundle.main.url(forResource: filename, withExtension: "wav") else {
            print("找不到音频文件")
            return nil
        }

        do {
            return try hapticEngine?.registerAudioResource(
                audioURL,
                options: [:]
            )
        } catch {
            print("音频注册失败: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func createPatternFromAHAP(_ filename: String) -> CHHapticPattern? {
        // Get the URL for the pattern in the app bundle.
        let patternURL = Bundle.main.url(forResource: filename, withExtension: "ahap")!
        
        do {
            // Read JSON data from the URL.
            let patternJSONData = try Data(contentsOf: patternURL, options: [])
            
            // Create a dictionary from the JSON data.
            let dict = try JSONSerialization.jsonObject(with: patternJSONData, options: [])
            
            if let patternDict = dict as? [CHHapticPattern.Key: Any] {
                // Create a pattern from the dictionary.
                return try CHHapticPattern(dictionary: patternDict)
            }
        } catch let error {
            print("Error creating haptic pattern: \(error)")
        }
        return nil
    }
}


#endif
