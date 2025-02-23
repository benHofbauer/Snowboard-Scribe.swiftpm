//
//  SwiftUIView.swift
//  Snowboard Scribe
//
//  Created by Ben Hofbauer on 2/23/25.
//

import SwiftUI
import SwiftData
import Charts

enum ridesSince:String, CaseIterable, Identifiable {
    case forever, year, quarter, month, week
    var id: Self { self }
    
    var date: Date {
        switch self {
        case .forever: return Calendar.current.date(from: DateComponents(year: 2000)) ?? Date.now
        case .year: return Calendar.current.date(byAdding: .year, value: -1, to: Date.now) ?? Date.now
        case .quarter: return Calendar.current.date(byAdding: .month, value: -3, to: Date.now) ?? Date.now
        case .month: return Calendar.current.date(byAdding: .month, value: -1, to: Date.now) ?? Date.now
        case .week: return Calendar.current.date(byAdding: .day, value: -7, to: Date.now) ?? Date.now
        }
    }
    
    var text:String {
        switch self {
        case .forever: "Forever"
        case .year: "Last Year"
        case .quarter: "Last 3 Months"
        case .month: "Last Month"
        case .week: "Last Week"
        }
    }
}

@available(iOS 17.0, *)
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newScreenShowing = false
    @State private var oldestDate: ridesSince = ridesSince.forever
    @Query(sort: \Trail.enjoyment, order:.reverse) var trails: [Trail]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Log Ride") {
                        newScreenShowing.toggle()
                    }
                }
                Section {
                    Picker("Rides in", selection: $oldestDate) {
                        Text("Forever")
                            .tag(ridesSince.forever)
                        Text("Last Year")
                            .tag(ridesSince.year)
                        Text("Last 3 Months")
                            .tag(ridesSince.quarter)
                        Text("Last Month")
                            .tag(ridesSince.month)
                        Text("Last Week")
                            .tag(ridesSince.week)
                    }
                    ChartView(searchDate: oldestDate.date)
                }
                Section(header: Text("**Favorite Trails**")) {
                    ForEach(0...10, id: \.self) { idx in
                        if idx < trails.count {
                            let trail = trails[idx]
                            HStack {
                                Text(trail.name)
                                Spacer()
                                Text("\(Int(trail.enjoyment))/10")
                                Symbol(rating: trail.rating, paddingDimension: CGFloat(15), dimension: CGFloat(20))
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $newScreenShowing) {
                RideView()
            }
        }
    }
    
}

#Preview {
    if #available(iOS 17.0, *) {
        HomeView()
    } else {
        // Fallback on earlier versions
    }
}
