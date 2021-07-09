//
//  PopularDestinationsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI
import MapKit
import Kingfisher

struct PopularDestinationsView: View{
    
    @ObservedObject var vm = DestinationViewModel()
    @State var isReload = false
    
    var body: some View{
        VStack{
            HStack{
                Text("Popular destinations")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                NavigationLink(
                    destination: NewDestination(parentVm: vm),
                    label: {
                        Text("Create")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(.label))
                    })
                
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8.0){
                    ForEach(vm.destinations ?? [], id: \.self) { destination in
                        NavigationLink(
                            destination: NavigationLazyView(PopularDestinationDetailsView(destination: destination, parentVm: vm)),
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

class DestinationDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetail?
    
    init(id: Int, name: String) {
        //make a network call
//        let name = "paris"
        let fixedUrlString = "http://localhost:8080/api/destination-detail/\(id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
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
    @ObservedObject var parentVm: DestinationViewModel
    
    let destination: Destination
    let destinationService = DestinationService()
    
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = false
    @State var starVote = 0
    @State var isConfirmVote = false
    @State var isVoteSuccess = false
    
    
    init(destination: Destination, parentVm: DestinationViewModel) {
        
        self.destination = destination
        
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.04, longitudeDelta: 0.04)))
        
        self.vm = .init(id: destination.id, name: destination.name)
        self.parentVm = parentVm
    }
    
    var body: some View{
        ScrollView{
            //if good then array, else then []
            
            if let photos = vm.destinationDetails?.photos {
                DestinationHeaderContainer(imageUrlStrings: vm.destinationDetails?.photos ?? photos)
                    .frame(height: 350)
            }
            
            VStack(alignment: .leading){
                HStack {
                    Text(destination.name)
                        .font(.system(size: 18, weight: .bold))
                        .alert(isPresented: $isVoteSuccess) {
                            Alert(title: Text("Success!"),
                                  message: Text("You just voted for \(destination.name)!"),
                                  dismissButton: .default(Text("OK")))
                        }
                    Spacer()
                        .alert(isPresented: $isConfirmVote) {
                            Alert(title: Text("Confirm vote?"),
                                  message: Text("Vote \(destination.name) with rank \(starVote)"),
                                  primaryButton: .default(Text("OK"), action: {
                                    self.destinationService.VoteDestination(destinationVote: DestinationVote(vote: starVote, destinationID: destination.id)) { resp in
                                        if resp.isSuccess {
                                            self.vm.destinationDetails?.vote = resp.rank
                                            self.isVoteSuccess = true
                                        }
                                    }
                                    self.destinationService.GetDestination { result in
                                        self.parentVm.destinations = result.result
                                    }
                                  }),
                                  secondaryButton: .destructive(Text("Cancel")))
                        }
                    Text("Vote").contextMenu {
                        ForEach(0..<5, id: \.self) { vote in
                            Button(action: {
                                starVote = vote + 1
                                isConfirmVote = true
                            }, label: {
                                Text("Choose star to vote: \(vote + 1)")
                                Image(systemName: "star.fill")
                            })
                        }
                    }
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .background(Color.orange)
                    .cornerRadius(10)
                }
                Text(destination.country)
                
                HStack{
                    if let vote = vm.destinationDetails?.vote {
                        ForEach(0..<vote, id: \.self){num in
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                        }.padding(.top, 2)
                        ForEach(0..<5 - vote, id: \.self){num in
                            Image(systemName: "star.fill")
                                .foregroundColor(.gray)
                        }.padding(.top, 2)
                        
                    } else {
                        ForEach(0..<5, id: \.self){num in
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                        }
                    }
                }.padding(.top, 2)
                
                HStack{
                    Text(vm.destinationDetails?.description ?? "No description")
                        .padding(.top, 4)
                        .font(.system(size: 14))
                    Spacer()
                }
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
            KFImage(URL(string: destination.imageName))
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

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HomeView()
//            HomeView()
//        }
//    }
//}
