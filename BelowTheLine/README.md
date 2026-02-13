# Below The Line: Shadow Courier Empire - Prototype Setup

## Installation on Android

1.  **Get the Project Files**:
    -   Download the `BelowTheLine` folder to your Android device.

2.  **Open in Godot 4 Mobile**:
    -   Open the Godot Editor app.
    -   Tap "Import".
    -   Navigate to `BelowTheLine/project.godot`.
    -   Tap "Open".

3.  **Run the Game**:
    -   Tap the "Play" button (triangle) in the top right.
    -   Select "Select Current" if asked about main scene, or it should default to `Scenes/MainMenu.tscn`.

## Controls

-   **Left Stick**: Steer.
-   **GAS**: Accelerate.
-   **BRAKE**: Brake / Reverse.
-   **USE**: Interact (Flip car if stuck).

## Gameplay Loop

1.  **Start Game**: Press "START GAME" in the menu.
2.  **Wait**: A contract will be assigned automatically after 1 second (or loaded from save).
3.  **Pickup**: Follow the **GREEN** marker on the minimap/world. Drive into the cylinder.
4.  **Deliver**: Follow the **RED** marker. Drive into it.
5.  **Heat**: Speeding and crashing increases Heat. Police will chase you if Heat gets high.
6.  **Repeat**: Wait for next contract. Progress is saved automatically.
