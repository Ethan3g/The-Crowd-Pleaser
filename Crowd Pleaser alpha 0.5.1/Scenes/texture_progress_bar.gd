extends TextureProgressBar


@export var timer_duration: float = 5.0  # Total time for the timer in seconds
var timer_value: float = 100.0  # Starting value of the timer (full)
var textureProgressBar: TextureProgress  # The TextureProgress node reference

func _ready():
	# Get the reference to the TextureProgress node
	texture_progress = $TextureProgressextends Node2D

# Declare variables for the TextureProgress node and textures
var progress_bar: TextureProgress
var background_texture: Texture2D
var progress_texture: Texture2D
var border_texture: Texture2D

func _ready():
	# Get the TextureProgress node
	progress_bar = $TextureProgress  # Use the node name directly as it is in the scene

	# Load the textures (replace these paths with your own texture paths)
	background_texture = load("res://Art Assets/UI_Timers/Expanded/MainTimer_Empty.png")
	progress_texture = load("res://Art Assets/UI_Timers/MainTimer_Bar.png")
	border_texture = load("res://path_to_your_border_image.png")

	# Set the textures to the progress bar
	progress_bar.texture_under = background_texture  # Background texture (empty state)
	progress_bar.texture_progress = progress_texture  # Progress texture (filled part)
	progress_bar.texture_over = border_texture  # Border texture (optional)

	# Optionally, set the initial value for the progress bar
	progress_bar.value = 0  # Set to 0 or any other value to start the progress
