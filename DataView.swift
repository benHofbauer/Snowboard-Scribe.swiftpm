//
//  dataView.swift
//
//  Created by Ben Hofbauer on 2/9/25.
//

import SwiftUI
import SwiftData

func getDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.none
    return dateFormatter.string(from: date)
}

@available(iOS 17, *)
func getUniqueDates(trails:[Trail]) -> ([String:[Trail]], [String]) {
    var newDict: [String:[Trail]] = [:]
    var keys: [String] = [String]()
    for trail in trails {
        let trailDate = getDate(date: trail.date)
        if var list = newDict[trailDate] {
            list.append(trail)
            newDict[trailDate] = list
        } else {
            newDict[trailDate] = [trail]
        }
    }
    
    for key in newDict.keys {
        keys.append(key)
    }
    
    keys.sort {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter.date(from: $0) ?? .now > dateFormatter.date(from: $1) ?? .now
    }
    
    return (newDict, keys)
}

struct Symbol: View {
    public var rating: Rating
    public var paddingDimension:CGFloat
    public var dimension:CGFloat
    
    var body: some View {
        HStack {
            if rating == Rating.green {
                Circle()
                    .frame(width:dimension)
                    .foregroundStyle(.green)
                    .padding(paddingDimension)
            } else if rating == Rating.blue {
                Rectangle()
                    .frame(width: dimension, height: dimension)
                    .foregroundStyle(.blue)
                    .padding(paddingDimension)
            } else if rating == Rating.black {
                Diamond()
                    .frame(width: dimension, height: dimension)
                    .foregroundStyle(.black)
                    .padding(paddingDimension)
            } else if rating == Rating.double {
                DoubleDiamond()
                    .frame(width: dimension, height: dimension)
                    .foregroundStyle(.black)
                    .padding(paddingDimension)
            }
        }
    }
}

@available(iOS 17.0, *)
struct DataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var trails: [Trail]
    @State private var newScreenShowing = false

    var body: some View {
        let (uniqueDates, days) = getUniqueDates(trails: trails)
        NavigationStack {
            List {
                Button("Log Ride") {
                    newScreenShowing.toggle()
                }
                
                ForEach(days, id:\.self) { day in
                    if let rides = uniqueDates[day] {
                        DayView(rides: rides, day:day)
                    }
                }
            }
            .listStyle(.sidebar)
            .sheet(isPresented: $newScreenShowing) {
                RideView()
            }
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        DataView()
            .modelContainer(for: Trail.self, inMemory: true)
    } else {
        // Fallback on earlier versions
    }
}
