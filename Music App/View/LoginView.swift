//
//  LoginView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/5/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    @State var emailID: String = "" //use SAME email for spotify account
    @State var password: String = ""

    //View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    
    var body: some View {
        VStack(spacing: 10){
            Text("Lets Sign You In")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            Text("Welcome back!")
                .font(.title3)
                .hAlign(.leading)
            VStack(spacing: 12){
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                                    
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                Button("Reset Password",action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                
                Button(action: loginUser){
                    //Login Button
                    Text("Sign In")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
                
            }
            
            //Register Button
            HStack{
                Text("Dont't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        
        //register view via Sheets
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        //MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser(){
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
            }catch{
                await setError(error)
            }
        }
        
    }
    
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            }catch{
                await setError(error)
            }
        }
        
    }
    // MARK: Displaying Errors VIA Alert
    
    func setError(_ error: Error) async{
        //MARK: UI Must be Uppdated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}
struct RegisterView: View {
    @State var emailID: String = "" //use SAME email for spotify account
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var bioLink: String = ""
    @State var userProfilePicData: Data?
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    var body: some View{
        VStack(spacing: 10){
            Text("Lets Register \nAccount")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            Text("Hello user, have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            
            //Register Button
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("Login Now"){
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            // MARK: Extracting UIImage From PhotoItem
            if let newValue{
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else{return}
                        //MARK: UI Must Be Updated on Main Thread
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    }catch{}
                }
            }
        }
        // MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions:{})
        
    }
    
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12){
            ZStack{
                if let userProfilePicData, let image = UIImage(data: userProfilePicData){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image("null_pfp")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture{
                showImagePicker.toggle()
            }
            .padding(.top,25)
            
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                
            
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                                
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio,axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Bio Link (optional)", text: $bioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))

            
            Button(action: registerUser){
                //Login Button
                Text("Sign Up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil)
            .padding(.top,10)
            
        }
    }
    
    func registerUser(){
        Task{
            do{
                //Creating Firebase Account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                //Uploading Profile Photo Into Firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                guard let imageData = userProfilePicData else {return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                //Downloading photo URL
                let downloadURL = try await storageRef.downloadURL()
                //Creating a user firestore object
                let user = User(username: userName, userBio: userBio, userBioLink: bioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                // Saving User Doc into Firestore database
                
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion:{
                    error in
                    if error == nil{
                        //MARK: Print Saved Successfully
                        print("Saved Successfully")
                    }
                })
                
            }catch{
                //MARK: Deleting Created Account In Case of Failure
                await setError(error)
            }
        }
    }
    // MARK: Displaying Errors VIA Alert
    
    func setError(_ error: Error) async{
        //MARK: UI Must be Uppdated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


extension View{
    // MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool) -> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
    
    //create a custom border with  padding
    func border(_ width: CGFloat,_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5,style: .continuous)
                    .stroke(color, lineWidth: width)
            }

    }
    
    //create a custom fill view with  padding
    func fillView(_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5,style: .continuous)
                    .fill(color)
            }

    }
    
}
