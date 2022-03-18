package main

import SDL "vendor:sdl2"
import IMG "vendor:sdl2/image"
import "core:fmt"
import "core:image/png"

main :: proc()
{
    if SDL.Init(SDL.InitFlags{.VIDEO}) < 0 do fmt.println("Failed to initialize SDL")

    window := SDL.CreateWindow("map", 100, 100, 1280, 720, SDL.WindowFlags{.SHOWN})
    if window == nil do fmt.println("Failed to create window")

    screen_surface := SDL.GetWindowSurface(window)

    map_png, error := png.load("resources/map.png")
    if error != nil do fmt.println("failed to load map png")
    Color :: [4]u8
    color: Color
    colors: [dynamic]Color
    i: uint
    for n in map_png.pixels.buf {
        if i == 0 do color[0] = n
        if i == 1 do color[1] = n
        if i == 2 do color[2] = n
        if i == 3 do color[3] = n
        i += 1
        if i == 4 {
            i = 0
            append(&colors, color)
            color = Color{}
        }
    }

    if .PNG not_in IMG.Init(IMG.InitFlags{.PNG}) do fmt.println("Failed to initialize IMG")

    grass := IMG.Load("resources/grass.png")
    if grass == nil do fmt.println("Failed to load resources/grass.png")

    coin := IMG.Load("resources/coin.png")
    if coin == nil do fmt.println("Failed to load resources/coin.png")

    spike := IMG.Load("resources/spike.png")
    if spike == nil do fmt.println("Failed to load resources/spike.png")

    running := true
    for running {
        event: SDL.Event
        for SDL.PollEvent(&event) != 0 {
            #partial switch event.type {
                case .QUIT:
                running = false
            }
        }

        i := 0
        for y in 0..<map_png.height {
            for x in 0..<map_png.width {
                switch {
                    case colors[i][0] == 102 && colors[i][1] == 57 && colors[i][2] == 49:
                    dest := SDL.Rect{i32(x) * 16, i32(y) * 16, 16, 16}
                    SDL.UpperBlitScaled(grass, nil, screen_surface, &dest)

                    case colors[i][0] == 172 && colors[i][1] == 50 && colors[i][2] == 50:
                    dest := SDL.Rect{i32(x) * 16, i32(y) * 16, 16, 16}
                    SDL.UpperBlitScaled(spike, nil, screen_surface, &dest)

                    case colors[i][0] == 251 && colors[i][1] == 242 && colors[i][2] == 54:
                    dest := SDL.Rect{i32(x) * 16, i32(y) * 16, 16, 16}
                    SDL.UpperBlitScaled(coin, nil, screen_surface, &dest)
                }
                i += 1
            }
        }

        SDL.UpdateWindowSurface(window)
    }

    IMG.Quit()
    SDL.Quit()
}