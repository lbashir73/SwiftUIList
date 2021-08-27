//
//  ContentView.swift
//  CoreDataMVVM
//
//  Created by Lisa on 7/27/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var itemListVM = ItemListViewModel()
    
    @State var isPresented = false              // display or hide modal view
    @State var sorting = 1                      // sort by name or creation date
    
    func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = itemListVM.items[index]
            itemListVM.delete( item: item )
        }
        itemListVM.getAllItems()
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Spacer()
                Text("LIST").padding()
                Spacer()
                Button(action: {
                        self.isPresented.toggle()
                }, label: {
                    Image( systemName: "plus.circle" )
                        .font( Font.system(.largeTitle) )
                        .foregroundColor(.black)
                })
            }
            
            // Segmented picker for selecting sort order
            Picker(selection: $sorting, label: Text("Sort"), content: {
                Text("Alpha").tag(1)
                Text("Date").tag(2)
            })
            .pickerStyle( SegmentedPickerStyle() )
            .onChange(of: sorting) { newValue in
                    if newValue == 1 {
                        itemListVM.items.sort { $0.name < $1.name }
                    } else {
                        itemListVM.items.sort { $0.dateCreated > $1.dateCreated }
                    }
                }
            
            // Sorted list
            List {
                ForEach( itemListVM.items, id: \.id ) { item in
                    Text("\( item.name )")
                }.onDelete( perform: deleteItem )
            }.border(Color.black)
        }
        .padding()
        .onAppear() {
            itemListVM.getAllItems()
        }
        .fullScreenCover( isPresented: $isPresented, content: {
            AddItemModalView( itemListVM: itemListVM )

        } )
    }
}

// Modal view for adding a new item
struct AddItemModalView: View {
    @ObservedObject var itemListVM = ItemListViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Spacer()
                    Text("ADD").padding()
                    Spacer()
                    Button( "Save" ) {
                        itemListVM.save()
                        itemListVM.getAllItems()
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                }.border(Color.black)
                Text("Garment name:")
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                TextField( "", text: $itemListVM.name )
                    .frame(height: 50.0)
                    .border(Color.black)
                Spacer()
            }.padding()
            .border(Color.black)
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
