# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Calendar' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  #Calenderに必要なライブラリ
  pod 'FSCalendar'
  pod 'CalculateCalendarLogic'

  # Firebase関連
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  
  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods

  # Pods for Calendar

  target 'CalendarTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CalendarUITests' do
    # Pods for testing
  end

end
