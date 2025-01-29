# Part I. Description of Overall Test Plan
Our senior project is a game using godot so many common testing strategies will not work. However, we will be using a combination of manual and automated testing. We will be using manual testing to test mostly functionality. We will be using automated testing to test performance, bugs and saving/loading.

For manual testing we will be conducting functional, usability, and exploratory testing. For functional testing, we will test each feature and ensure that it performs in it's intended way. For usability testing, we will test to ensure that the game is easy to use and that the user can easily navigate through the game. For exploratory testing, we will test to ensure that the game is working as intended at the boundaries of the game. An example of this would be testing to ensure that the game does not crash when their is the max amount of plants and animals in the game.

Regarding automated testing, we will bw conducting performance , bug , and save/load testing. Performance testing is important because we want to ensure that the game runs smoothly and without any lag. Examples of this include frame rate analysis, stress testing, load testing, and resource usage testing. Our Save/load testing will be conducted using unit tests. Unit tests are important in this situation because we want to ensure that the game is saving and loading correctly. An example of this would be testing to ensure that the save files are being created and loaded correctly. Our Bug testing will be abnormal / boundary testing. These are important because it gives us a warning of undefined behavior. An example of this would be a warning when there are more animals in the game then there should be.

# Part II. Test Case Descriptions

List a series of 10-25 tests for validating your project outcomes. For each test case provide the following:
1.  test case identifier (a number or unique name)
2.  purpose of test
3.  description of test
4.  inputs used for test
5.  expected outputs/results
6.  normal/abnormal/boundary case indication
7.  blackbox/whitebox test indication
8.  functional/performance test indication
9.  unit/integration test indication

Note that some of these categories may be inappropriate for your project and may be omitted if you can justify doing so. For items 6-9, only one term should apply.

1. Test Case Identifier: 1
    - Purpose: This test will ensure that the player can move the camera around the map.
    - Description: The player will move the camera around the map using the arrow keys. The camera should move in the direction of the arrow key that is pressed. The camera should not move off the map.
    - Inputs: Arrow keys
    - Expected Outputs/Results: The camera will move around the map as intended and will not move off the map.
    - Normal Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
2. Test Case Identifier: 2
    - Purpose: This test will ensure that the player can place a building on the map.
    - Description: The player will place a building on the map by clicking on the building and then clicking on the map where they want to place the building. The building should be placed on the map where the player clicked.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The building will be placed on the map where the player clicked.
    - Normal Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
3. Test Case Identifier: 3
    - Purpose: This test will ensure that the player can place an animal on the map.
    - Description: The player will place an animal on the map by clicking on the animal and then clicking on the map where they want to place the animal. The animal should be placed on the map where the player clicked.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The animal will be placed on the map where the player clicked.
    - Normal Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
4. Test Case Identifier: 4
    - Purpose: This test will ensure that the player can place a plant on the map.
    - Description: The player will place a plant on the map by clicking on the plant and then clicking on the map where they want to place the plant. The plant should be placed on the map where the player clicked.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The plant will be placed on the map where the player clicked.
    - Normal Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
5. Test Case Identifier: 5
    - Purpose: This test will ensure that the game does not crash when the player has the max amount of plants on the map.
    - Description: The player will place the max amount of plants on the map. The game should not crash.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not crash.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
6. Test Case Identifier: 6
    - Purpose: This test will ensure that the game does not crash when the player has the max amount of animals on the map.
    - Description: The player will place the max amount of animals on the map. The game should not crash.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not crash.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
7. Test Case Identifier: 7
    - Purpose: This test will ensure that the game does not crash when the player has the max amount of buildings on the map.
    - Description: The player will place the max amount of buildings on the map. The game should not crash.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not crash.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
8. Test Case Identifier: 8
    - Purpose: This test will ensure that the game does not crash when the player has the max amount of animals and plants on the map.
    - Description: The player will place the max amount of animals and plants on the map. The game should not crash.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not crash.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
9. Test Case Identifier: 9
    - Purpose: This test will ensure that the game does not crash when the player has the max amount of animals, plants, and buildings on the map.
    - Description: The player will place the max amount of animals, plants, and buildings on the map. The game should not crash.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not crash.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
10. Test Case Identifier: 10
    - Purpose: This test will ensure that the game does not crash when the player has the max amount of animals, plants, and buildings on the map and tries to place another animal, plant, or building.
    - Description: The player will place the max amount of animals, plants, and buildings on the map and then try to place another animal, plant, or building. The game should not crash.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not crash.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
11. Test Case Identifier: 11
    - Purpose: This test will ensure the game does not allow for baby animals to be born if there are too many animals on the map.
    - Description: The player will place the max amount of animals on the map and then wait for a baby animal to be born. The game should not allow for a baby animal to be born.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not allow for a baby animal to be born.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
12. Test Case Identifier: 12
    - Purpose: This test will ensure the game does not allow for baby plants to be born if there are too many plants on the map.
    - Description: The player will place the max amount of plants on the map and then wait for a baby plant to be born. The game should not allow for a baby plant to be born.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not allow for a baby plant to be born.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
13. Test Case Identifier: 13
    - Purpose: This test will ensure the game stays within the minimum frame rate limit under normal conditions. This is to load test the game because it is operating under the expected resource and computing load.
    - Description: The player will play the game and the game should stay within the minimum frame rate limit.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will stay within the minimum frame rate limit.
    - Normal Case Indication
    - Blackbox Test Indication
    - Performance Test Indication
    - Unit Test Indication
14. Test Case Identifier: 14
    - Purpose: This test will ensure the game stays within the minimum frame rate limit under abnormal conditions. This is to stress test the game because it is operating under the maximum resource and computing load.
    - Description: The player will place the max amount of animals, plants, and buildings on the map and then play the game. The game should stay within the minimum frame rate limit.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will stay within the minimum frame rate limit.
    - Abnormal Case Indication
    - Blackbox Test Indication
    - Performance Test Indication
    - Unit Test Indication
15. Test Case Identifier: 15
    - Purpose: This test will ensure the game does not take up more than 75% of the CPU under normal conditions. This is to ensure proper resource usage. 
    - Description: The player will play the game and the game should not take up more than 75% of the CPU.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not take up more than 75% of the CPU.
    - Normal Case Indication
    - Blackbox Test Indication
    - Performance Test Indication
    - Unit Test Indication
16. Test Case Identifier: 16
    - Purpose: This test will ensure the game does not take up more than 75% of the CPU under abnormal conditions. This is to ensure proper resource usage.
    - Description: The player will place the max amount of animals, plants, and buildings on the map and then play the game. The game should not take up more than 75% of the CPU.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not take up more than 75% of the CPU.
    - Abnormal Case Indication
    - Blackbox Test Indication
    - Performance Test Indication
    - Unit Test Indication
17. Test Case Identifier: 17
    - Purpose: This test will ensure that the player can save the game.
    - Description: The player will save the game by clicking on the save button. The game should be saved and the player should be able to load the game from the save file.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will be saved and the player will be able to load the game from the save file.
    - Normal Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
18. Test Case Identifier: 18
    - Purpose: This test will ensure that there are no conditions where there can be more than the max amount of animals on the map.
    - Description: The player will place the max amount of animals on the map and then try to place another animal. The game should not allow for another animal to be placed.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not allow for another animal to be placed. The log will display a message indicating that the player cannot place another animal.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
19. Test Case Identifier: 19
    - Purpose: This test will ensure that there are no conditions where there can be more than the max amount of plants on the map.
    - Description: The player will place the max amount of plants on the map and then try to place another plant. The game should not allow for another plant to be placed.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not allow for another plant to be placed. The log will display a message indicating that the player cannot place another plant.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication
20. Test Case Identifier: 20
    - Purpose: This test will ensure that there are no conditions where there can be more than the max amount of buildings on the map.
    - Description: The player will place the max amount of buildings on the map and then try to place another building. The game should not allow for another building to be placed.
    - Inputs: Mouse clicks
    - Expected Outputs/Results: The game will not allow for another building to be placed. The log will display a message indicating that the player cannot place another building.
    - Boundary Case Indication
    - Blackbox Test Indication
    - Functional Test Indication
    - Unit Test Indication

# Part III. Test Case Matrix:

| Test Case Identifier | Normal/Abnormal/Boundary Case | Blackbox/Whitebox Test | Functional/Performance Test | Unit/Integration Test |
|----------------------|-------------------------------|------------------------|-----------------------------|-----------------------|
| 1                    | Normal                        | Blackbox               | Functional                  | Unit                  |
| 2                    | Normal                        | Blackbox               | Functional                  | Unit                  |
| 3                    | Normal                        | Blackbox               | Functional                  | Unit                  |
| 4                    | Normal                        | Blackbox               | Functional                  | Unit                  |
| 5                    | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 6                    | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 7                    | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 8                    | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 9                    | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 10                   | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 11                   | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 12                   | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 13                   | Normal                        | Blackbox               | Performance                 | Unit                  |
| 14                   | Abnormal                      | Blackbox               | Performance                 | Unit                  | 
| 15                   | Normal                        | Blackbox               | Performance                 | Unit                  |
| 16                   | Abnormal                      | Blackbox               | Performance                 | Unit                  |
| 17                   | Normal                        | Blackbox               | Functional                  | Unit                  |
| 18                   | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 19                   | Boundary                      | Blackbox               | Functional                  | Unit                  |
| 20                   | Boundary                      | Blackbox               | Functional                  | Unit                  |
