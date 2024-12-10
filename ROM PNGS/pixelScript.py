from PIL import Image


# Correct image path using raw string or forward slashes
image_path = 'GameOverScreen.png'



# Load the image
image = Image.open(image_path)


# Get the image size (width, height)
width, height = image.size


# Function to convert RGB value to 2-bit per channel (scaling from 0-255 to 0-3)
def rgb_to_2bit(rgb):
    return tuple(min(3, round(c / 85)) for c in rgb)  # Scaling each channel to 0-3




# Create and print the formatted output
for y in range(height):
    for x in range(width):
        # Get RGB value at (x, y)
        rgb = image.getpixel((x, y))
       


       
        # Check if the pixel is black (i.e., RGB values are close to (0, 0, 0))
        # Convert coordinates to 10-bit binary strings
        y_bin = f"{y:09b}"  # 10-bit binary for y-coordinate
        x_bin = f"{x:09b}"  # 10-bit binary for x-coordinate
       
        # Combine them to create a 20-bit binary string
        coords_bin = y_bin + x_bin
       
        # Convert the RGB value to a 2-bit per channel representation
        rgb_2bit = rgb_to_2bit(rgb)
       
        # Combine RGB values into a single 6-bit value (2 bits per channel)
        rgb_combined = f"{rgb_2bit[0]:02b}{rgb_2bit[1]:02b}{rgb_2bit[2]:02b}"
        formatted_output = f'when "{coords_bin}" => data <= "{rgb_combined}";'


        # Create the formatted output string
        if rgb_combined == "000000":
            print(formatted_output)
       
        # Print the formatted output