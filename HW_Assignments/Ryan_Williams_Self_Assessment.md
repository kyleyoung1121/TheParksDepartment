# Senior Design Self-Assessment
## Part A
For our wildlife simulator project, I contributed the visual aspects of our animals. The build demonstrated at EXPO had seven unique animals, with assets for an eighth going unused. 

To represent an animal in our game, I would first research the subject, finding photographs at different angles, along with videos of the animal in motion. From this reference packet, I would sculpt the animal’s body in the Blender modelling software from a primitive object. A low-poly style was used for every asset in our game to save time and establish an artistic voice.

Next, I defined the UV of the model, showing Blender how to apply textures to its surface. By indicating which edges were seams, I essentially wrapped the object in a flat piece of paper. I then painted a texture onto this UV map, using Blender’s inbuilt tools for paintbrushes. 

Next, I would define a skeleton for the model. I manually created and placed each bone, labeled to loosely match the real animal’s skeleton. I then weighted the skeleton telling Blender which vertices and faces were affected by each bone. I would go in and “weight paint” after an initial calculation to ensure the model properly warped with bone movements.

I then would animate the rigged model, defining several animations that can be called from code in Godot. Each part of the pipeline to this point must be executed well, or flaws will show, requiring revisits to several steps. References of the animal in motion were used at this stage to ensure the animations lined up with what one would expect in the wild.

I repeated this process for each animal, except in such cases as part of another animal could be adjusted into a new one (example: the cooper’s hawk was adapted from extensive edits to the turkey vulture’s model). If species showed sexual dimorphism in the wild, I cloned the first file, then adjusted the new one to match the other sex. I also created juvenile variants of each animal, should they be different from the adults, but went unused.

The core competencies I built were in 3D modelling and animation. I honed my skills along the entire pipeline from default grey box to howling wolf. 

My greatest obstacle was Blender’s learning curve. I’d used Blender somewhat in the past, but this went far beyond anything I’d ever done, especially in texturing and animation. The cumulative nature of the pipeline was also unforgiving of mistakes. I succeeded, however, in creating a set of charming animals that I am proud of. The solutions I provided were sufficiently plug-and-play to be used by my teammates without much difficulty.

## Part B
Our group created a fully playable 3D environment simulator, based on the native species of Ohio. The gameplay is in managing a complex system of plants and animals, attempting to keep populations in balance while introducing more and more species to the habitat.

I learned that group work can be very fulfilling. The four of us tended to specialize with only some knowledge overlap between the other three members. This allowed us to become experts on our respective roles, working on what we knew best without getting in other teammates’ ways. Because we all collaborated over Github and smartly committed to avoid unnecessary merge conflicts, we were able to work in tandem in wildly different areas of the overall project. 

We occasionally had some difficulty where only one person on the team knew how to accomplish a difficult task, making that take longer, but there was enough overlap between our skills to make that a rare occurrence.

My efforts on the project were equal to that of the other members. I firmly believe that this project wouldn't have been remotely as good without all four of us. We all additionally found features that inspired us to work harder and implement. Kyle’s work on some of our fundamental systems, like placing objects and the day/night cycle, was especially appreciated.
