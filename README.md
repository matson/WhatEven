#  WhatEven!

# An app designed to combat fast-fashion and avoid the "What I got vs. what I ordered"

-> Recently Converted to SwiftUI <- 

Background: 

This app was created to combat fast fashion and scams found all other instagram and other popular social media
outlets that target consumerism. 
Users will be able to post picture of their clothing, and if they wish may also post items other than clothing. 

I added a couple of posts and comments to test the functionalty.  You will see these upon logging in and seeing
the dashboard. 

To add later to improve user experience:
-The UI. I will add more features
-User will be able to edit posts and comments. 

There would also be some sort of AI implementation where if there is the same item posted then there would be a way to compare the post to another post of the same item and warn the user that it already exists.  

-There will be a score system where the highest score would signify the most ridiculous item/scam, and then
the lowest will sigify the least horrible item.  
-Top scored posts would be featured on most recent feed at all times. (since it is popular)


Instructions: 

-Make sure you are running Version 15.3 of Xcode, and the app includes the Firebase SDK
-Run the application and register.  The new user info will get stored to Firebase. 
-Once you register, navigate to the portal and login with those user credentials. 
-You will be taken to the homepage where you will be able to create posts, comments, and delete your own posts and comments. 

📱 Features

  Authentication

  - LoginView - User authentication with clean, modern design. Includes
  option to register and invites new users to sign up for an account
  - RegisterView - Account creation with username, email, and password
  validation. Seamlessly navigates back to login after successful
  registration

  Main App Flow

  - Home Feed - Displays other users' posts with Instagram-style layout.
  Includes option to create a new "bloop" (reality check post)
  - PostView - Utilizes PhotoPicker and camera integration to capture
  images for new posts
  - AddBloopFeature - Takes the selected image from PostView and allows
  users to add product details and honest reviews
  - DetailsView - Comprehensive post view showing full image, interaction
  buttons (likes, comments), comment count, and preview of recent comments
  - CommentView - Full comments feed displaying all user comments on a
  specific item with reply functionality

  Navigation

  - NavigationCoordinator - Centralized routing system managing navigation
  stack and screen transitions throughout the app

  Design System

  - Consistent gradient backgrounds and LexendDeca typography
  - White card-based UI with translucent elements
  - Modern SwiftUI architecture with MVVM pattern
  - Responsive design optimized for iOS devices






