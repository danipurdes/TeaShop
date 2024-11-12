extends TextureRect

@export var normal_cursor:Texture2D
@export var up_arrow:Texture2D
@export var down_arrow:Texture2D

func change_cursor(new_cursor_type):
    match new_cursor_type:
        "up_arrow":
            texture = up_arrow
        "down_arrow":
            texture = down_arrow
        _:
            texture = normal_cursor