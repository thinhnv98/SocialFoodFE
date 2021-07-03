//
//  PopularDestinationsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI
import MapKit

struct PopularDestinationsView: View{
    
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "1.eiffel", latitude: 48.855014, longitude: 2.341231),
        .init(name: "Tokyo", country: "Japan", imageName: "1.japan", latitude: 35.67988, longitude: 139.7695),
        .init(name: "New York", country: "US", imageName: "1.newyork", latitude: 40.71592, longitude: -74.0055),
    ]
    
    var body: some View{
        VStack{
            HStack{
                Text("Popular destinations")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8.0){
                    ForEach(destinations, id: \.self) { destination in
                        NavigationLink(
                            destination: NavigationLazyView(PopularDestinationDetailsView(destination: destination)),
                            label: {
                                PopularDestinationTile(destination: destination)
                                .padding(.bottom)
                            })
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct DestinationDetail: Decodable {
    let description: String
    let photos: [String]
}

class DestinationDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetail?
    
    init(name: String) {
        //make a network call
//        let name = "paris"
        let fixedUrlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: fixedUrlString)
        else {return}
        URLSession.shared.dataTask(with: url) { data, resp, err in
            //make sure to check your err & resp
            
            DispatchQueue.main.async {
                guard let data = data else {return}
                
                do {
                    
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetail.self, from: data)
                    
                } catch {
                    print("Failed to decode JSON, ", error)
                }
            }
        }.resume()
    }
}

struct PopularDestinationDetailsView: View {
    
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let destination: Destination
    
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = false
    
    
    
    init(destination: Destination) {
        
        self.destination = destination
        
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.04, longitudeDelta: 0.04)))
        
        self.vm = .init(name: destination.name)
    }
    
    let imageUrlStrings = [
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/2240d474-2237-4cd3-9919-562cd1bb439e",
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702",
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531",
    ]
    
    var body: some View{
        ScrollView{
            //if good then array, else then []
            
            if let photos = vm.destinationDetails?.photos {
                DestinationHeaderContainer(imageUrlStrings: vm.destinationDetails?.photos ?? photos)
                    .frame(height: 350)
            }
            
//            Image(destination.imageName)
//                .resizable()
//                .scaledToFill()
//                .clipped()
            
            VStack(alignment: .leading){
                Text(destination.name)
                    .font(.system(size: 18, weight: .bold))
                Text(destination.country)
                
                HStack{
                    ForEach(0..<5, id: \.self){num in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top, 2)
                
                HStack{
                    Text(vm.destinationDetails?.description ?? "")
                        .padding(.top, 4)
                        .font(.system(size: 14))
                    Spacer()
                }
//
//                HStack{Spacer()}
            }
            .padding(.horizontal)
            
            HStack {
                Text("Location")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                
                Button(action: {
                    isShowingAttractions.toggle()
                }, label: {
                    Text("\(isShowingAttractions ? "Hide" : "Show") Attractions")
                        .font(.system(size: 14, weight: .semibold))
                })
                
                Toggle("Title title", isOn: $isShowingAttractions)
                    .labelsHidden()
            }.padding(.horizontal)
            
            Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? attractions : []) { attraction in
                MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitute)) {
                    CustomeMapAnnotation(attraction: attraction)
                }
            }
            .frame(height: 300)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "1.eiffel", latitude: 48.858605, longitute: 2.2946),
        .init(name: "Champs-Elysees", imageName: "1.newyork", latitude: 48.866867, longitute: 2.311780),
        .init(name: "Louvre Museum", imageName: "1.museum", latitude: 48.860288, longitute: 2.337789)
    ]
}

struct CustomeMapAnnotation: View {
    let attraction: Attraction
    
    var body: some View {
        VStack{
            Image(attraction.imageName)
                .resizable()
                .frame(width: 80, height: 60)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.init(white: 0, alpha: 0.5)))
                
                )
            
            Text(attraction.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.init(white: 0, alpha: 0.5)))
                
                )
        }.shadow(radius: 5)
    }
}

struct Attraction: Identifiable {
    let id = UUID().uuidString
    
    let name, imageName: String
    let latitude, longitute: Double
}

struct PopularDestinationTile: View {
    
    let destination: Destination
    
    var body: some View{
        VStack(alignment: .leading, spacing: 0){
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(4)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(Color(.label))
            
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .foregroundColor(.gray)
        }
        .asTile()
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
