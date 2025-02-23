//
//  dataView.swift
//
//  Created by Ben Hofbauer on 2/9/25.
//

import SwiftUI
import SwiftData
import Charts

struct trailDifficulty: Identifiable, Hashable {
    var id = UUID()
    var rating: Rating
    var name:String
    var count:Int
}

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

@available(iOS 17, *)
func difficultySplits(trails:[Trail]) -> [trailDifficulty] {
    var splits = [0, 0, 0, 0]
    
    for trail in trails {
        if trail.rating == Rating.green {
            splits[0] += 1
        } else if trail.rating == Rating.blue {
            splits[1] += 1
        } else if trail.rating == Rating.black {
            splits[2] += 1
        } else {
            splits[3] += 1
        }
    }
    let green = trailDifficulty(rating: .green, name: "Green", count: splits[0])
    let blue = trailDifficulty(rating: .blue, name: "Blue", count: splits[1])
    let black = trailDifficulty(rating: .black, name: "Black", count: splits[2])
    let dblack = trailDifficulty(rating: .double, name: "Double Black", count: splits[3])
    var out = [green, blue, black, dblack]
    out = out.sorted { $0.count > $1.count }
    return out
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
        let splits = difficultySplits(trails: trails)
        NavigationStack {
            List {
                Section {
                    Chart(splits, id: \.self) { split in
                        SectorMark(
                            angle: .value("Number of runs", split.count),
                            innerRadius: .ratio(0.618),
                            angularInset: 1.5
                        )
                        .cornerRadius(5)
                        .foregroundStyle(by: .value("Rating", split.name))
                    }
                    .frame(width: 325, height: 325)
                    .chartForegroundStyleScale([
                        "Green" : .green,
                        "Blue" : .blue,
                        "Black" : .black,
                        "Double Black" : .gray
                    ])
                    .chartBackground { chartProxy in
                      GeometryReader { geometry in
                        let frame = geometry[chartProxy.plotAreaFrame]
                        VStack {
                            ForEach(splits, id: \.self) { split in
                                HStack {
                                    Text("\(split.count)")
                                    Symbol(rating: split.rating, paddingDimension: CGFloat(0), dimension: CGFloat(15))
                                }
                            }
                        }
                        .position(x: frame.midX, y: frame.midY)
                      }
                    }
                    .chartLegend(alignment: .bottom, spacing: CGFloat(25))
                    .padding()
                }
                
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
