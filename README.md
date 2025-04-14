# The Park Department

## Table of Contents
- [Core Information](#core-information)
  - [Team Members](#team-members)
  - [Project Abstract](#project-abstract)
- [Project Description (Assignment #2)](#project-description-assignment-2)
- [User Interface Specification](#user-interface-specification)
- [Test Plan and Results](#test-plan-and-results)
- [User Manual](#user-manual)
- [Spring Final PPT Presentation](#spring-final-ppt-presentation)
- [Final Expo Poster](#final-expo-poster)
- [Assessments](#assessments)
- [Summary of Hours and Justification](#summary-of-hours-and-justification)
- [Summary of Expenses](#summary-of-expenses)
- [Appendix](#appendix)


## Core Information
### Team Members
- Nathan Suer
  - Email: natesuer@gmail.com, suerns@mail.uc.edu 
- Ryan Williams
  - Email: willi5r7@mail.uc.edu
- Kyle Young
  - Email: young4kg@mail.uc.edu
- Owen Richards
  - Email: richaroc@mail.uc.edu 
- William Hawkins III (Advisor)
  - Email: hawkinwh@ucmail.uc.edu

### Project Abstract
This educational video game teaches responsible forestry, species identification, and invasive species control through an engaging simulation. The game combines the task of growing and maintaining a wildlife reserve with protecting native species, while defusing threats like wildfires or invasive species. Players also grapple with key questions through play, such as raising funds while preserving their mission. 

## Project Description (Assignment #2)
[Project Description](HW_Assignments/Project-Description.md)

## User Interface Specification
### Main Menu
img
Start Game - Starts the game
Settings - Pop-up settings menu
Exit Game - Closes Godot

### GUI
There are eight main buttons the user can interact with on the in-game user interface. Working from left to right:
img

Left:
The first button, “Building,” will pull up a menu of all of our available buildings. Some buildings, like the research center, can help the user by allowing them to get an extra animal release per day, or the fence can be used to separate or enclose species you need to control the population of. 
img

The next is the “Animal Status” button. This will list the current count of all of the animals in your environment. This is useful for the user to see their progress on balancing their ecosystem. 
img

Similar to the previous button, “Plant Status” will pull up a menu displaying the current count of grass in your environment. This can help the user understand how having too many herbivores can affect your food count. 
img

The last button on the left half is the “Releasing” button. This one is most similarly compared to the building menu. Once clicked, a menu pops up of all of the current animals you can release into your environment.
img

Middle:

Pause, Play, and Fast Forward Buttons. These buttons can be used to help the speed of your environment. 
img
Pause - Stops all interactions and systems like the animals and guests.
Play - 1x speed (normal speed).
Fast Forward - 2x speed.

These buttons can be best compared to the “Sims” games. Allowing the user to generate income quickly at the expense of losing some control or pausing the game to intervene with a potential issue in your environment before it happens. 

Right:
The last button located on the right is the “Fun Fact” button. 
img

Clicking the guidebook pulls up a pop-up menu of a random fun fact about the animals we designed, all Ohio native species.
img

### Settings Menu
img
Resolution: 800x600, 1280x720, 1920x1080 (default), 2560x1440, 3840x2160, 
Window Type: Full Screen (default), Windowed, and Borderless Windowed - *There is a known glitch with the windowed button not working if it’s selected first post-game launch.*
FPS: 30, 60, 120, 144, and 240 - default set based off system settings.
Quality (non-functional): Low, Medium (default), and High

### Escape Menu
img
Continue - Return to Game
Save Game (non-functional) - Save the current state of the user's ecosystem to their device.
Settings - Same as above.
Quit to Menu - Returns to the main menu screen.
Exit Game - Closes the application.

## Test Plan and Results 
In this document is our test plan, I will go through the results in this Document. 

[Test Plan](HW_Assignments\Test_Plan.md)

### Test Results
1. Test Case Identifier: 1
    - Description: The player will move the camera around the map using the arrow keys. The camera should move in the direction of the arrow key that is pressed. The camera should not move off the map.
    - Description of execution: Feature was tested by pressing the arrow keys and observing the camera movement. The camera was moved to the edge of the map and was allowed past it.
    - Result: Partially successful.
2. Test Case Identifier: 2
    - Description: The player will place a building on the map by clicking on the building and then clicking on the map where they want to place the building. The building should be placed on the map where the player clicked.
    - Description of execution: Feature was tested by clicking on the building and then clicking on the map. The building was placed on the map where the player clicked. 
    - Result: Passed
3. Test Case Identifier: 3
    - Description: The player will place an animal on the map by clicking on the animal and then clicking on the map where they want to place the animal. The animal should be placed 
    - Description of execution: Feature was tested by clicking on the animal and then clicking on the map. The animal was placed on the map where the player clicked.
    - Result: Passed
4. Test Case Identifier: 4
    - Description: The player will place a plant on the map by clicking on the plant and then clicking on the map where they want to place the plant. The plant should be placed on 
    - Description of execution: Feature was tested by clicking on the plant and then clicking on the map. The plant was placed on the map where the player clicked.
    - Result: Passed
5. Test Case Identifier: 5
    - Description: The player will place the max amount of plants on the map. The game should not crash.
    - Description of execution:  Feature was tested by placing the max amount of plants on the map. The game did not crash.
    - Result: Passed
6. Test Case Identifier: 6
    - Description: The player will place the max amount of animals on the map. The game should not crash.
    - Description of execution: Feature was tested by placing the max amount of animals on the map. The game did not crash.
    - Result: Passed
7. Test Case Identifier: 7
    - Description: The player will place the max amount of buildings on the map. The game should not crash.
    - Description of execution: Feature was tested by placing the max amount of buildings on the map. The game did not crash.
    - Result: Passed
8. Test Case Identifier: 8
    - Description: The player will place the max amount of animals and plants on the map. The game should not crash.
    - Description of execution:  Feature was tested by placing the max amount of animals and plants on the map. The game did not crash.
    - Result: Passed
9. Test Case Identifier: 9
    - Description: The player will place the max amount of animals, plants, and buildings on the map. The game should not crash.
    - Description of execution: Feature was tested by placing the max amount of animals, plants, and buildings on the map. The game did not crash.
    - Result: Passed
10. Test Case Identifier: 10
    - Description: The player will place the max amount of animals, plants, and buildings on the map and then try to place another animal, plant, or building. The game should not crash.
    - Description of execution: Feature was tested by placing the max amount of animals, plants, and buildings on the map and then trying to place another animal, plant, or building. The game did not crash.
    - Result: Passed
11. Test Case Identifier: 11
    - Description: The player will place the max amount of animals on the map and then wait for a baby animal to be born. The game should not allow for a baby animal to be born.
    - Description of execution: Feature was tested by placing the max amount of animals on the map and then waiting for a baby animal to be born. The game did not allow for a baby animal to be born.
    - Result: Passed
12. Test Case Identifier: 12
    - Description: The player will place the max amount of plants on the map and then wait for a baby plant to be born. The game should not allow for a baby plant to be born.
    - Description of execution: Feature was tested by placing the max amount of plants on the map and then waiting for a baby plant to be born. The game did not allow for a baby plant to be born.
    - Result: Passed
13. Test Case Identifier: 13
    - Description: The player will play the game and the game should stay within the minimum frame rate limit.
    - Description of execution: Feature was tested by playing the game and observing the frame rate. The game stayed within the minimum frame rate limit.
    - Result: Passed
14. Test Case Identifier: 14
    - Description: The player will place the max amount of animals, plants, and buildings on the map and then play the game. The game should stay within the minimum frame rate limit.
    - Description of execution: Feature was tested by placing the max amount of animals, plants, and buildings on the map and then playing the game. The game stayed within the minimum frame rate limit.
    - Result: Passed 
15. Test Case Identifier: 15
    - Description: The player will play the game and the game should not take up more than 75% of the CPU.
    - Description of execution: Feature was tested by playing the game and observing the CPU usage. The game did not take up more than 75% of the CPU.
    - Result: Passed
16. Test Case Identifier: 16
    - Description: The player will place the max amount of animals, plants, and buildings on the map and then play the game. The game should not take up more than 75% of the CPU.
    - Description of execution: Feature was tested by placing the max amount of animals, plants, and buildings on the map and then playing the game. The game did not take up more than 75% of the CPU.
    - Result: Passed
17. Test Case Identifier: 17
    - Description: The player will save the game by clicking on the save button. The game should be saved and the player should be able to load the game from the save file.
    - Description of execution:  Feature did not end up being implemented.
    - Result: Failed
18. Test Case Identifier: 18
    - Description: The player will place the max amount of animals on the map and then try to place another animal. The game should not allow for another animal to be placed.
    - Description of execution: Feature was tested by placing the max amount of animals on the map and then trying to place another animal. The game did not allow for another animal to be placed.
    - Result: Passed
19. Test Case Identifier: 19
    - Description: The player will place the max amount of plants on the map and then try to place another plant. The game should not allow for another plant to be placed.
    - Description of execution:  Feature was tested by placing the max amount of plants on the map and then trying to place another plant. The game did not allow for another plant to be placed.
    - Result: Passed
20. Test Case Identifier: 20
    - Description: The player will place the max amount of buildings on the map and then try to place another building. The game should not allow for another building to be placed.
    - Description of execution: Feature was tested by placing the max amount of buildings on the map and then trying to place another building. The game did not allow for another building to be placed.
    - Result: Passed

## User Manual
TODO

## Spring Final PPT Presentation
TODO

## Final Expo Poster
TODO

## Assessments
TODO

### Initial Self-Assessments
- [Nathan Suer's Initial Self-Assessment](HW_Assignments/Nathan_Suer_Individual_Capstone_Assessment.md)
- [Ryan Williams's Initial Self-Assessment](HW_Assignments/Ryan_Williams_Individual_Capstone_Assessment.md)
- [Kyle Young's Initial Self-Assessment](HW_Assignments/Kyle_Young_Individual_Capstone_Assessment.md)
- [Owen Richards's Initial Self-Assessment](HW_Assignments/Owen_Richards_Individual_Capstone_Assessment.md)

### Final Self-Assessments
- [Nathan Suer's Final Self-Assessment](HW_Assignments\Nathan_Suer_Self_Assessment.md)
- [Ryan Williams's Final Self-Assessment]() TODO
- [Kyle Young's Final Self-Assessment]() TODO
- [Owen Richards's Final Self-Assessment]() TODO

## Summary of Hours and Justification
TODO
(one per individual team member)

##  Summary of Expenses
There has no been no expenses.

## Appendix
### References, citations, links to code repositories, and meeting notes.
We have not used or referenced any other persons work. We are using the Godot engine, which is an open source game engine (https://github.com/godotengine/godot).
