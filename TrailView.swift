//
//  TrailView.swift
//
//  Created by Ben Hofbauer on 2/7/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct TrailView: View {
    @Bindable var trail: Trail
    var trailNo: Int
    var editing = false
    var body: some View {
        List {
            if !editing {
                TextField("Trail \(trailNo + 1)", text: $trail.name)
            } else {
                TextField("Trail Name", text: $trail.name)
            }
            HStack {
                Text("Trail Rating")
                Spacer()
                RatingView(trail: trail)
            }
            Toggle(isOn: $trail.trees) {
                HStack {
                    Text("Trees")
                }
            }
                .tint(trail.rating.color)
            Toggle(isOn: $trail.moguls) {
                HStack {
                    Text("Moguls")
                }
            }
                .tint(trail.rating.color)
            Toggle(isOn: $trail.powder) {
                HStack {
                    Text("Powder")
                }
            }
                .tint(trail.rating.color)
            VStack {
                HStack {
                    Text("Enjoyment: \(Int(trail.enjoyment))/10")
                    Spacer()
                }
                Slider(value: $trail.enjoyment, in: 0...10, step: 1)
                    .tint(trail.rating.color)
            }
        }
    }
}

#Preview {
    if #available(iOS 17, *) {
        TrailView(trail: Trail(date: Date.now, rating: Rating.green, enjoyment: 0.0, name: ""), trailNo: 0)
    } else {
        // Fallback on earlier versions
    }
}
