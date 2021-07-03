//
//  NewDestination.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 03/07/2021.
//

import SwiftUI

struct NewDestination: View {
    
    let destinationService = DestinationService()

    @ObservedObject var parentVm: DestinationViewModel
    
    @State var destination: Destination = Destination(id: 0, name: "", country: "", imageName: "", imageData: "", description: "", latitude: 0, longitude: 0)
    @State var destinationDetail: DestinationDetail = DestinationDetail(vote: 0, description: "", photos: [])
    
    
    @State var latitude: String = ""
    @State var longitude: String = ""
    
    @State var isShowingImagePicker = false
    @State var imageInBlackBox = UIImage()
    @State var isCreating = false
    @State var createNotificationTitle = ""
    @State var createNotificationDescription = ""
    @State var colorState = false
    var typeColor: Color {
        switch colorState {
            case false:
                return .red
            default:
                return .green
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Infomation")) {
                    TextField("Destination's name", text: $destination.name)
                    TextField("Destination's country", text: $destination.country)
                    TextField("Decscription", text: $destination.description)
                }
                Section(header: Text("Position")) {
                    TextField("Destination's latitude", text: $latitude)
                    TextField("Destination's logitude", text: $longitude)
                }
                .alert(isPresented: $isCreating) {
                    Alert(title: Text(self.createNotificationTitle)
                            .foregroundColor(typeColor),
                          message: Text(self.createNotificationDescription),
                          dismissButton: .default(Text("OK").foregroundColor(typeColor)))
                }
                
                Section(header: Text("Image")) {
                    VStack(alignment: .leading) {
                        Image(uiImage: imageInBlackBox)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 60)
                            .border(Color.black, width: 1)
                            .clipped()
                        
                        Button(action: {
                            self.isShowingImagePicker.toggle()
                        }, label: {
                            Text("Select image")
                                .font(.system(size: 12))
                        })
                        .sheet(isPresented: $isShowingImagePicker, content: {
                            ImagePickerView(isPresented: $isShowingImagePicker, selectedImage: self.$imageInBlackBox)
                        })
                    }
                }
            }.navigationBarTitle("New Destination", displayMode: .inline)
            Spacer()
            
            //Create
            
            Button(action: {
                self.isCreating = true
                self.createNotificationTitle = "Creating, waiting for response..."
                self.destination.imageData = imageToBase64(image: self.imageInBlackBox)
                self.destination.latitude = Double(self.latitude)!
                self.destination.longitude = Double(self.longitude)!
                
                //Call service
                self.destinationService.CreateNewDestination(destination: self.destination) { result in
                    if result.isSuccess == true {
                        self.createNotificationTitle = "Succeed"
                        self.createNotificationDescription = "OK"
                        self.destinationService.GetDestination { result in
                            self.parentVm.destinations = result.result
                        }
                        self.colorState = true
                    } else {
                        self.createNotificationTitle = "Failed"
                        self.createNotificationDescription = "Cancel"
                    }
                }
            }, label: {
                Text("Create")
                    .bold()
                    .frame(width: 150, height: 50, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
            })
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    //trick part
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                print(selectedImageFromPicker)
                self.parent.selectedImage = selectedImageFromPicker
            }
            self.parent.isPresented = false
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
