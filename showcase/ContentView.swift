//
//  ContentView.swift
//  AdoreVenture - Showcase Version
//
//  Created by Dagmawi Mulualem
//  This is a simplified version for portfolio demonstration
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = IdeasViewModel()
    @State private var selectedLocation = "San Francisco"
    @State private var selectedCategory = "travel"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                headerView
                
                // Location and Category Selectors
                selectionView
                
                // Ideas List
                ideasListView
                
                Spacer()
            }
            .padding()
            .navigationTitle("AdoreVenture")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadInitialIdeas()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "map.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            Text("Discover Amazing Adventures")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("AI-powered recommendations for your next adventure")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Selection View
    private var selectionView: some View {
        VStack(spacing: 16) {
            // Location Picker
            HStack {
                Text("Location:")
                    .fontWeight(.medium)
                
                Picker("Location", selection: $selectedLocation) {
                    Text("San Francisco").tag("San Francisco")
                    Text("New York").tag("New York")
                    Text("Los Angeles").tag("Los Angeles")
                    Text("Seattle").tag("Seattle")
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
            }
            
            // Category Picker
            HStack {
                Text("Category:")
                    .fontWeight(.medium)
                
                Picker("Category", selection: $selectedCategory) {
                    Text("Travel").tag("travel")
                    Text("Date Ideas").tag("date")
                    Text("Local Activities").tag("local")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
            }
            
            // Load Ideas Button
            Button(action: loadIdeas) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                    Text("Find Adventures")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    // MARK: - Ideas List View
    private var ideasListView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recommended Activities")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if !viewModel.ideas.isEmpty {
                    Text("\(viewModel.ideas.count) ideas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if viewModel.isLoading {
                loadingView
            } else if viewModel.ideas.isEmpty {
                emptyStateView
            } else {
                ideasList
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Finding amazing adventures...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No adventures found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Try selecting a different location or category")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private var ideasList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.ideas) { idea in
                    IdeaCardView(idea: idea)
                }
            }
        }
    }
    
    // MARK: - Actions
    private func loadInitialIdeas() {
        // Load sample ideas for demonstration
        viewModel.loadSampleIdeas()
    }
    
    private func loadIdeas() {
        viewModel.loadIdeas(for: selectedLocation, category: selectedCategory)
    }
}

// MARK: - Idea Card View
struct IdeaCardView: View {
    let idea: Idea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(idea.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(idea.place)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    
                    Text(String(format: "%.1f", idea.rating))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
            
            // Description
            Text(idea.blurb)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(3)
            
            // Details
            HStack {
                // Duration
                Label(idea.duration, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Price
                Text(idea.priceRange)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            
            // Tags
            if !idea.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(idea.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - View Model
class IdeasViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadIdeas(for location: String, category: String) {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.ideas = self.generateSampleIdeas(for: location, category: category)
            self.isLoading = false
        }
    }
    
    func loadSampleIdeas() {
        ideas = generateSampleIdeas(for: "San Francisco", category: "travel")
    }
    
    private func generateSampleIdeas(for location: String, category: String) -> [Idea] {
        // Sample data for demonstration
        let sampleIdeas = [
            Idea(
                id: "1",
                title: "Golden Gate Bridge Walk",
                blurb: "Experience the iconic Golden Gate Bridge with a scenic walk across the bay.",
                rating: 4.8,
                place: "Golden Gate Bridge",
                duration: "1-2 hours",
                priceRange: "Free",
                tags: ["outdoor", "scenic", "iconic"],
                address: "Golden Gate Bridge, San Francisco, CA",
                phone: nil,
                website: nil,
                bookingURL: nil,
                bestTime: "Early morning or sunset",
                hours: ["24/7"]
            ),
            Idea(
                id: "2",
                title: "Alcatraz Island Tour",
                blurb: "Explore the historic Alcatraz Island and learn about its fascinating prison history.",
                rating: 4.6,
                place: "Alcatraz Island",
                duration: "3-4 hours",
                priceRange: "$45 per person",
                tags: ["historic", "tour", "educational"],
                address: "Alcatraz Island, San Francisco, CA",
                phone: "(415) 561-4900",
                website: "https://www.nps.gov/alcatraz",
                bookingURL: "https://www.alcatrazcruises.com",
                bestTime: "Morning tours",
                hours: ["9:00 AM - 6:30 PM"]
            ),
            Idea(
                id: "3",
                title: "Fisherman's Wharf Exploration",
                blurb: "Discover the vibrant Fisherman's Wharf with its shops, restaurants, and sea lions.",
                rating: 4.4,
                place: "Fisherman's Wharf",
                duration: "2-3 hours",
                priceRange: "Free to explore",
                tags: ["shopping", "dining", "family-friendly"],
                address: "Fisherman's Wharf, San Francisco, CA",
                phone: nil,
                website: nil,
                bookingURL: nil,
                bestTime: "Afternoon",
                hours: ["10:00 AM - 10:00 PM"]
            )
        ]
        
        return sampleIdeas
    }
}

// MARK: - Data Models
struct Idea: Identifiable, Codable {
    let id: String
    let title: String
    let blurb: String
    let rating: Double
    let place: String
    let duration: String
    let priceRange: String
    let tags: [String]
    let address: String?
    let phone: String?
    let website: String?
    let bookingURL: String?
    let bestTime: String?
    let hours: [String]?
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
