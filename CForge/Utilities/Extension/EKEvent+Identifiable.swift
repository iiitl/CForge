//
//  EKEvent+Identifiable.swift
//  CForge
//
//  Created by Kartikey Chaudhary on 12/04/26.
//
import Foundation
import EventKit

extension EKEvent: @retroactive Identifiable {
    public var id: String {
        self.eventIdentifier ?? UUID().uuidString
    }
}
