README
IOS Chess: Richard Morley, Max Moghadam and Zachary Tanverakul

For IOS Chess we used a swift as our programming language and Firebase for authentication as well as our database.
IOS Chess is a single player chess game where the user plays agains an AI program designed for chess, this game implements all of the standard chess moves and rules. IOS Chess keeps track of the number of games a user has won and displays them in our leader board which ranks them based on number of games won.

Files Structure:
We have a class file for each chess piece, each class sets the rules for how the piece can be moved.
The Chessboard.swift, ChessGame.swift and viewcontroller.swift all implement the chess game functionality such as turns, the ai plaer and checking check conditions. MenuViewcontroller.swift runs the menu functionality, RankingsViewcontroller.swift implements the sorting of players based on number of wins and then ranks them from most wins to fewest wins. Both login and signUp viewcontroller files handle user creation and fetching or existing users respectively and both communicate with our firebase database to either create or fetch the user. The piece.swift class acts as a factory from which all pieces are made following which subclass they belong to. All of our UI components were designed in main.storyboard.

Running IOS Chess (Must be on Mac OS):
Download the latest version of xcode
Clone IOS Chess repo
open IOSChess.xcworkspace
once files have completed building press Shift Command K to clean the project 
Then on the Xcode nav bar press the play icon
If you would like to play IOS Chess on your own device in the drop down menu where it shows the simulator being used (right of play and stop) select the connected device, IOS chess will then be installed on your device.

Playing IOS Chess:
Once you reach the log in screen click the create account button, if you already have an account enter your email and password associated with IOS Chess
Enter your email and chosen password
Once on the home page click the Play button to begin the game
After the game you will have the option of playing again or returning to the menu
From the home page you can also view the ranking of all IOS Chess players, rank is based on total number of wins

