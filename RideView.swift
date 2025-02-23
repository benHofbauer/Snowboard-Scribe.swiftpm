//
//  RideView.swift
//
//  Created by Ben Hofbauer on 2/7/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct RideView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var date:Date = .now
    @State var trails:[Trail] = []
    @State var numTrails: Int = 1
    
    var body: some View {
        Form {
            Section {
                DatePicker("Date of Ride Down", selection: $date, displayedComponents: .date)
                    .onChange(of: date) {
                        for trail in trails {
                            trail.date = date
                        }
                    }
            }
            
            Section {
                Stepper("# of Trails On Ride: \(numTrails)", value: $numTrails, in:1...6)
                    .onChange(of: numTrails, initial: true) {
                        while numTrails > trails.count {
                            trails.append(Trail(date: date, rating: Rating.green, enjoyment: 0.0, name: ""))
                        }
                        while numTrails < trails.count {
                            trails.removeLast()
                            if let toBeRemoved = trails.last {
                                modelContext.delete(toBeRemoved)
                            }
                        }
                    }
            }
            
            
            ForEach(0..<trails.count, id: \.self) { idx in
                Section {
                    TrailView(trail: trails[idx], trailNo: idx)
                }
            }
            
            Section {
                Button("Save") {
                    for idx in 0..<trails.count {
                        modelContext.insert(trails[idx])
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        RideView(date: Date.now)
    } else {
        // Fallback on earlier versions
    }
}
