//
//  dataView.swift
//
//  Created by Ben Hofbauer on 2/9/25.
//

import SwiftUI
import SwiftData

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
struct SearchView: View {
    @State private var dateSince:Date = Calendar.current.date(byAdding: .year, value: -1, to: Date.now) ?? Date.now
    @State private var name:String = ""
    @State private var enjoyment:Double = 0.0
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Search")) {
                    DatePicker("All rides since: ", selection: $dateSince, displayedComponents: .date)
                    TextField("Name of Trail", text: $name)
                    VStack {
                        HStack {
                            Text("More Enjoyable Than: \(Int(enjoyment))/10")
                            Spacer()
                        }
                        Slider(value: $enjoyment, in: 0...10, step:1)
                    }
                }
                
                DataView(searchDate: dateSince, searchText: name, searchRating: enjoyment)
            }
            .listStyle(.sidebar)
        }
    }
}

@available(iOS 17.0, *)
struct DataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var trails: [Trail]
    
    init(searchDate: Date = .now, searchText: String = "", searchRating: Double = 0.0) {
        _trails = Query(
            filter: predicate(
                searchText: searchText,
                searchDate: searchDate,
                searchRating: searchRating)
        )
    }

    var body: some View {
        let (uniqueDates, days) = getUniqueDates(trails: trails)
        if days.isEmpty {
            Text("No saved rides found. Start recording them on the homescreen to track your progress!")
        }
        
        ForEach(days, id:\.self) { day in
            if let rides = uniqueDates[day] {
                DayView(rides: rides, day:day)
            }
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        SearchView()
    } else {
        // Fallback on earlier versions
    }
}
