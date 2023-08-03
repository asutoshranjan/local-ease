# LocalEase

Building an online store platform using Appwrite and Flutter.

# About App

an online store platform connecting users with local shops and small businesses. The client application would have two interfaces, one for sellers and one for customers. Depending on the type of account you create user will be routed to that section. With real-time store details, users will stay updated on the latest offerings. Subscribe to their favorite stores for personalized notifications about stock, exclusive offers, and special discounts. Users can choose their location to get nearby stores with their site, distance, opening and closing times, and contact details. For sellers, the app would provide an intuitive store form for easy management to create and update store details, showcase products, and manage inventory effectively. Subscriber notifications would help engage with customers and can view details of their subscribed users.

## Installation Guide

1. **Install Flutter on your machine**

    Install Flutter by selecting the operating system on which you are installing Flutter: [Flutter installation tutorial](https://flutter.dev/docs/get-started/install)

    To check if you have Flutter installed along with the proper necessary SDKs installed
    run `flutter doctor`
    
2. **Fork and Clone the Repo**

    Fork the repo by clicking on the **Fork** button on the top right corner of the page.
    
    To clone this repository, run `git clone https://github.com/asutoshranjan/local-ease.git`
    
    Make sure you are inside `local-ease` directory
    
    
3. **Get Packages**

    - From the terminal: Run `flutter pub get`.
      _OR_
    - From Android Studio/IntelliJ: **Click Packages get** in the action ribbon at the top of `pubspec.yaml`.
    - From VS Code: **Click Get Packages** located in right side of the action ribbon at the top of `pubspec.yaml`.

    After the above steps, you should see the following message in the terminal   
    
4. **Create Appwrite Project**
    
    Go to [Appwrite Cloud](https://cloud.appwrite.io) make sure you are logged in with an Appwrite account and click on Create project button from the dashboard.<br>
    Add a **new Appwrite project** with the desired name and now your Appwrite project is up and running<br>
    Now add a new **database** and the collections with the required schema. Refer [Blog](https://asutosh.hashnode.dev/building-an-online-store-platform-using-appwrite-and-flutter-localease)
    Right next to the name of your project, database, collections, and storage bucket, you have the copy ID button. Use that to copy your IDs; replace them in the client app.
    
    
    
5. **Add Flutter App to your Appwrite Project**

    Go back to the Overview menu and **Add a Platform**. Add your Flutter app. Add the app name and package name and the app will be added to your project.
    



### Run the App

  On terminal:

- Check that an Android device is running by running `flutter devices`. If none are shown, follow the device-specific instructions on the [Install](https://flutter.dev/docs/get-started/install) page for your OS.
- Run the app with the following command: `flutter run`
