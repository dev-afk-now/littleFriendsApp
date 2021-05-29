//
//  PlacesListItem.swift
//  firstDemo
//
//  Created by Никита Дубовик on 09.05.2021.
//

import SwiftUI
import MapKit
import FirebaseStorage

struct ListItemView: View {
    
    @State var item: Place
    
    @State var image: UIImage?
    @Binding var userLocation: CLLocationCoordinate2D?
    
    
    var body: some View {

            NavigationView {
                VStack {
                    VStack {
                        HStack {
                        Text(item.title).font(.custom("kohinoor bangla", size: 35, relativeTo: .title)).fontWeight(.bold).lineLimit(1).frame(alignment: .leading).padding(.horizontal, 3)
                            Spacer()
                    }
                        HStack {
                            Text("\(item.formattingDate(date: item.publishTime, withoutTime: true) ?? "00:00")").font(.custom("AppleSDGothicNeo-thin", size: 22, relativeTo: .title)).padding(.horizontal, 8)
                            Spacer()
                        }
                    }.padding(.horizontal)
                    Divider()
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        ZStack {
                            if image == nil {
                            Image(systemName: "photo").resizable().frame(width: 400, height: 300, alignment: .center).foregroundColor(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        
                        } else {
                            Image(uiImage: image!).resizable().frame(width: 400, height: 300, alignment: .center).foregroundColor(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                        }
                        }
                        Divider()
                        HStack {
                            if userLocation?.latitude ?? 0 > 0 || userLocation != nil {
                                let dist = item.distance(point1: CLLocation(latitude: item.latitude, longitude: item.longitude), point2: CLLocation(latitude: userLocation?.latitude ?? 0, longitude: userLocation?.longitude ?? 0))
                                    Text("\(dist > 100 ? ">100" : String(format: "%.f", dist))km").font(.system(size: 36, weight: .light, design: .default)).frame(width: UIScreen.main.bounds.width / 3, height: 35, alignment: .center).foregroundColor(.gray).padding(.leading, 30)
                            } else {
                                Text("World").font(.system(size: 36, weight: .light, design: .default)).frame(width: UIScreen.main.bounds.width / 3, height: 35, alignment: .center).foregroundColor(.gray).padding(.leading, 30)
                            }
                            Text(item.isFounded ? "Я нашел" : "Я потерял")
                            
                            Divider()
                            Text("\(item.animalType ?? "animal")").font(.system(size: 50)).frame(width: UIScreen.main.bounds.width / 3 - 10, height: 35, alignment: .center)
                            Divider()
                            Text("\(item.gender == "female" ? "♁" : "♂︎")").font(.system(size: 70)).frame(width: UIScreen.main.bounds.width / 3 - 10, height: 35, alignment: .leading).foregroundColor( item.gender == "female" ? .pink : .blue).padding(.leading)
                        }.frame(width: UIScreen.main.bounds.width - 30, height: 60, alignment: .center).padding(.vertical)
                        
                        HStack {
                            Text("+\(item.phoneNumber)").font(.system(size: 35, weight: .light, design: .default)).frame(height: 35, alignment: .leading).padding(.horizontal)
                            Spacer()
                            Image(systemName: "phone").resizable().frame(width: 35, height: 30).padding(.horizontal
                            )
                        }.frame(width: UIScreen.main.bounds.width, height: 10, alignment: .leading).foregroundColor(.gray)
                        
                        VStack {
                            ScrollView {
                                Text(item.title).font(.custom("AppleSDGothicNeo", size: 26, relativeTo: .footnote)).padding([.top, .horizontal])
                                Text(item.subtitle).font(.custom("AppleSDGothicNeo-thin", size: 24, relativeTo: .footnote)).padding([.bottom, .horizontal])
                            }
                        }.background(Color.gray.opacity(0.4)).cornerRadius(15).frame(width: UIScreen.main.bounds.width - 20)
                    }.frame(width: UIScreen.main.bounds.width - 40).frame(maxHeight: .infinity).padding(.bottom, 110).padding(.horizontal)
            }
            }.frame(maxHeight: .infinity).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).onAppear { downloadImage(item) }
    }

    private func downloadImage(_ item: Place) {
        let storage = Storage.storage()
        storage.reference().child("\(item.imageID)").getData(maxSize: 1 * 1024 * 1024 * 1024) { imageData, err in
            print("image loaded")
            guard err == nil else { print("An error occur - \(err!.localizedDescription)"); return }
            if let thisImage = imageData {
                image = UIImage(data: thisImage)
            }
        }
    }
}



