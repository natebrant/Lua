-- var = import or require the file push
push= require "push"
Class= require"class"
require "Paddle"
require "Ball"


WINDOW_WIDTH=720
WINDOW_HEIGHT=720
VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=432
PADDLE_SPEED=300
muliscore={0,0,0,0}
PADDLE_SPEED1,PADDLE_SPEED2,PADDLE_SPEED3,PADDLE_SPEED4=300,300,300,300


love.window.setTitle("pong")
game=0
sounds={["paddle_hit"]=love.audio.newSource("sounds/paddle_hit.wav","static"),
        ["score"]=love.audio.newSource("sounds/score.wav","static"),
        ["wall_hit"]=love.audio.newSource("sounds/wall_hit.wav","static")}


-- a function to start up the window that starts the game
function love.load()
    -- uses nearest naighbot filtering on upscaling and downscaling 
    math.randomseed=(os.time())
    love.graphics.setDefaultFilter("nearest","nearest")

    smallFont=love.graphics.newFont("font.ttf",8)
    largeFont=love.graphics.newFont("font.ttf",32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        
        fullscreen=false,
        resizable=true,
        vsync=true
    })
    p1score=7
    p2score=7
    p3score=7
    p4score=7
    server=math.random(0,1)
    player4=Paddle(VIRTUAL_WIDTH/2-100,VIRTUAL_HEIGHT-24,50,6) -- creates all paddles
    player3=Paddle(VIRTUAL_WIDTH/2-100,30,50,5)
    player2=Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-50,5,40)
    player1=Paddle(10,30,5,40)
    
    ball=Ball()
    ball:reset()
    
    gameState="start"
end

function love.resize(w,h)
    push:resize(w,h)
end

-- this function is ran every frame,pass in dt
-- dt is delta time /change in sec sinece the last frame
function love.update(dt)

    if gameState == "serve" then
        ball.dy=math.random(-50,50)
        if server == 1 then
            ball.dx= math.random(140,200)
        else
            ball.dx= -math.random(140,200)
        end
    end
    
    if gameState == "done" then
        ball:reset()
        p1score=7
        p2score=7
        p3score=7
        p4score=7
    end
    -- player one movement
    if love.keyboard.isDown("w") then
        -- move up do paddlespeed scaled by the dt
        player1.dy=-PADDLE_SPEED1
    elseif love.keyboard.isDown("s") then
        player1.dy=PADDLE_SPEED1
    else
        player1.dy=0
    end
    if love.keyboard.isDown("up") then
        -- move up do paddlespeed scaled by the dt
        player2.dy=-PADDLE_SPEED2
    elseif love.keyboard.isDown("down") then
        player2.dy=PADDLE_SPEED2
    else
        player2.dy=0
    end
    if love.keyboard.isDown("i") then
        -- move up do paddlespeed scaled by the dt
        player3.dx=-PADDLE_SPEED3
    elseif love.keyboard.isDown("o") then
        player3.dx=PADDLE_SPEED3
    else
        player3.dx=0
    end
    if love.keyboard.isDown("z") then
        -- move up do paddlespeed scaled by the dt
        player4.dx=-PADDLE_SPEED4
    elseif love.keyboard.isDown("x") then
        player4.dx=PADDLE_SPEED4
    else
        player4.dx=0
    end

    
    if gameState == "play" then
        if love.keyboard.isDown("r") then -- resets the ball 
            ball:reset()
        end
        if ball:collide(player1) then -- check if ball collides will paddles and makes go different way
            
            ball.x= player1.x+5
            ball.Dx=-ball.Dx *1.03
            sounds["paddle_hit"]:play()
            if ball.Dy <0 then
                ball.Dy=-math.random(10,150)
            else
                ball.Dy=math.random(10,150)
            end

        end
        if ball:collide(player2) then-- check if ball collides will paddles and makes go different way
            ball.x=player2.x-5
            ball.Dx=-ball.Dx  *1.03
            sounds["paddle_hit"]:play()
            if ball.Dy <0 then
                ball.Dy=-math.random(10,150)
            else
                ball.Dy=math.random(10,150)
            end

        end
        if ball:collide(player3) then-- check if ball collides will paddles and makes go different way
            ball.y=player3.y+5
            ball.Dx=-ball.Dx  *1.03
            sounds["paddle_hit"]:play()
            if ball.Dx <VIRTUAL_WIDTH/2 then
                ball.Dy=math.random(210/2,330/2)
                ball.Dx=math.random(-90,90)
            else
                ball.Dy=-math.random(210/2,330/2)
                ball.Dx=math.random(-90,90)
            end
        end
        if ball:collide(player4) then-- check if ball collides will paddles and makes go different way
            ball.y=player4.y-5
            ball.Dx=-ball.Dx 
            sounds["paddle_hit"]:play()
            if ball.Dx <VIRTUAL_WIDTH/2 then
                ball.Dy=-math.random(210/2,330/2)
                ball.Dx=math.random(-90,90)
            else
                ball.Dy=math.random(210/2,330/2)
                ball.Dx=math.random(-90,90)
            end
        end
        player1:update(dt) -- updates where player is 
        player2:update(dt)
        player3:update2(dt)
        player4:update2(dt)

        ball:update(dt) -- updates where ball is 
    
        -- check if ball is pass the paddle
        if ball.y < 0 then
            muliscore={0,0,0,muliscore[4]+1} -- add one to his score combo 
            if muliscore[4] == 3 then -- if score is 3 half his speed
                PADDLE_SPEED4=150
            else 
                PADDLE_SPEED4=300
            end
            p4score= p4score - 1 --  - the score by one
            game=4 -- used to see whos is serving
            if p4score==0 then -- check if that was the last point they lost 
                winner="green" 
                gameState="done"
            else  -- if not winner reset ball 
                ball:reset()
                gameState="serve"
            sounds["paddle_hit"]:play() 
            end
        end
        if ball.y > VIRTUAL_HEIGHT then -- same as one above 
            muliscore={0,0,muliscore[3]+1,0}
            if muliscore[3] == 3 then
                PADDLE_SPEED3=150
            else
                PADDLE_SPEED3=300
            end
            p3score= p3score - 1
            game=3
            if p3score==0 then
                winner="blue"
                gameState="done"
            else
                ball:reset()
                gameState="serve"
            sounds["paddle_hit"]:play() 
            end
        end

        if ball.x<0 then        -- same as one above 
            muliscore={0,muliscore[2]+1,0,0}
            if muliscore[2] == 3 then
                PADDLE_SPEED1=150
            else
                PADDLE_SPEED1=300
            end
            p1score= p1score - 1
            game=1
            sounds["paddle_hit"]:play()
            if p1score==0 then
                winner="red"
                gameState="done"
            else
                ball:reset()
                gameState="serve"
            end
        end
        if ball.x>VIRTUAL_WIDTH then    -- same as one above 
            muliscore={muliscore[1]+1,0,0,0}
            if muliscore[2] == 3 then
                PADDLE_SPEED2=150
            else
                PADDLE_SPEED2=300
            end
            p2score= p2score - 1
            game=2
            sounds["paddle_hit"]:play()
            if p2score==0 then
                winner="yellow"
                gameState="done"
            else
                ball:reset()
                gameState="serve"
            end
        end
    end
    
end


function FPS()-- gets fps and prints it into the top left
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,255,0,255)
    love.graphics.print("FPS:"..tostring(love.timer.getFPS()),10,10)
end





-- draw on the screen the letters
-- update the screen with infomation draw anything that is needed
function love.keypressed(key)
    if key == "escape" then -- quits 
        love.event.quit()
    elseif key == "enter" or key == "return" then -- mores the game to the next state
        if gameState == "start" then
            gameState="serve"
        elseif gameState =="serve"then
            gameState= "play"
        elseif gameState == "done" then
            gameState='play'
        end
    end
end

function love.draw()
    push:apply("start")
    love.graphics.clear(40,42,52,255)--takes an r,g,b,a val 40 45 52 255 
    --clear screen and reset
    love.graphics.setFont(smallFont)
    if gameState == "start" then
        love.graphics.printf("Hello Start state!",0,20,VIRTUAL_WIDTH,"center")
        love.graphics.printf("Press Enter to begin",0,40,VIRTUAL_WIDTH,"center")
    elseif gameState == "play"then
        love.graphics.printf(" ",0,20,VIRTUAL_WIDTH,"center")
    elseif gameState =="serve" then -- checks who scored and said there serve 
        if game == 1 then
            love.graphics.printf("Hello red serve!",0,20,VIRTUAL_WIDTH,"center")
        elseif game == 2 then
            love.graphics.printf("Hello yellow serve!",0,20,VIRTUAL_WIDTH,"center")
        elseif game == 3 then
            love.graphics.printf("Hello green serve!",0,20,VIRTUAL_WIDTH,"center")
        elseif game == 4 then
            love.graphics.printf("Hello blue serve!",0,20,VIRTUAL_WIDTH,"center")
        elseif game == 0 then 
            love.graphics.printf("Hello serve serve!",0,20,VIRTUAL_WIDTH,"center")
        end
        love.graphics.printf("Press Enter to begin",0,40,VIRTUAL_WIDTH,"center")
    elseif gameState =="done" then -- prints player green Wins
        love.graphics.printf("Player "..tostring(winner).." wins",0,200,VIRTUAL_WIDTH,"center")
        love.graphics.printf("Press Enter to begin",0,40,VIRTUAL_WIDTH,"center")
    end
    
    
    love.graphics.setFont(largeFont)
    love.graphics.setColor(255, 0, 21)
    love.graphics.printf(tostring(p1score),100,50,VIRTUAL_WIDTH,"center")
    love.graphics.setColor(242, 238, 5)
    love.graphics.printf(tostring(p2score),-100,50,VIRTUAL_WIDTH,"center")
    
    love.graphics.setColor(5, 237, 74)
    love.graphics.printf(tostring(p3score),100,350,VIRTUAL_WIDTH,"center")
    love.graphics.setColor(0, 8, 255)
    love.graphics.printf(tostring(p4score),-100,350,VIRTUAL_WIDTH,"center")
    love.graphics.setColor(242, 238, 5)
    ball:render()
    love.graphics.setColor(255, 0, 21)-- sets colors of paddles to match the scoore color 
    player1:render()
    love.graphics.setColor(242, 238, 5)-- sets colors of paddles to match the scoore color 
    player2:render()
    love.graphics.setColor(0, 8, 255)-- sets colors of paddles to match the scoore color 
    player3:render()
    love.graphics.setColor(5, 237, 74)-- sets colors of paddles to match the scoore color 
    player4:render()
    FPS()
    push:apply("end")
end


