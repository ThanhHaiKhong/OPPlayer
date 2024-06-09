//
//  AirPlayView.swift
//
//
//  Created by Thanh Hai Khong on 6/6/24.
//

import SwiftUI
import AVKit

struct AirPlayView: UIViewRepresentable {
    
    let routePickerView: AVRoutePickerView
    @Binding var isConnected: Bool
    
    init(routePickerView: AVRoutePickerView, isConnected: Binding<Bool>) {
        self.routePickerView = routePickerView
        self._isConnected = isConnected
    }
    
    func makeUIView(context: Context) -> AVRoutePickerView {
        routePickerView.isHidden = true
        routePickerView.prioritizesVideoDevices = false
        routePickerView.tintColor = .white
        routePickerView.activeTintColor = .green
        routePickerView.delegate = context.coordinator
        
        return routePickerView
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self) { routePickerView in
            
        }
    }
    
    // MARK: - Private Methods
    
    private func checkAirPlayConnection() -> Bool {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        for output in currentRoute.outputs {
            if output.portType == AVAudioSession.Port.airPlay {
                return true
            }
        }
        return false
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, AVRoutePickerViewDelegate {
        var parent: AirPlayView
        var didEndPresentingRoutes: (AVRoutePickerView) -> Void
        
        init(parent: AirPlayView, didEndPresentingRoutes: @escaping (AVRoutePickerView) -> Void) {
            self.parent = parent
            self.didEndPresentingRoutes = didEndPresentingRoutes
        }
        
        func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
            // AirPlay route picker view is about to be presented
        }
        
        func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
            // AirPlay route picker view did end presenting
            didEndPresentingRoutes(routePickerView)
        }
    }
}

// MARK: - AVRoutePickerView Extension

extension AVRoutePickerView {
    
    public func toggleAirPlay() {
        let routePickerButton = subviews.first(where: { $0 is UIButton }) as? UIButton
        routePickerButton?.sendActions(for: .touchUpInside)
    }
}
