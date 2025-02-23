//
//  SwiftUIView.swift
//  Snowboard Scribe
//
//  Created by Ben Hofbauer on 2/23/25.
//

import SwiftUI
import SwiftData
import Charts

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

@available(iOS 17.0, *)
func predicate(searchText: String, searchDate: Date, searchRating: Double) -> Predicate<Trail> {
    let calendar = Calendar.autoupdatingCurrent
    let start = calendar.startOfDay(for: searchDate)

    return #Predicate<Trail> { trail in
        (searchText.isEmpty || trail.name.contains(searchText))
        &&
        (trail.date >= start && trail.enjoyment >= searchRating)
    }
}

@available(iOS 17, *)
struct ChartView: View {
    @Query var trails: [Trail]
    
    init(searchDate: Date = .now, searchText: String = "", searchRating: Double = 0.0) {
        _trails = Query(
            filter: predicate(
                searchText: searchText,
                searchDate: searchDate,
                searchRating: searchRating)
        )
    }
    
    var body: some View {
        let splits = difficultySplits(trails: trails)
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

}

#Preview {
    if #available(iOS 17, *) {
        ChartView()
    } else {
        // Fallback on earlier versions
    }
}
