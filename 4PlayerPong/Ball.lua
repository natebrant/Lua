Ball= Class{}

function Ball:init()
    self.x=VIRTUAL_WIDTH/2-2
    self.y=VIRTUAL_HEIGHT/2-2
    self.dy=0
    self.width=5
    self.height=5
end
function Ball:reset()
    self.x=VIRTUAL_WIDTH/2-2
    self.y=VIRTUAL_HEIGHT/2-2
    x=math.random(1,2) -- starts going in random drienctions
    if game == 0 then
        if x == 1 then
            self.Dx=math.random(2)== 1 and 100 or -100
            self.Dy=math.random(-50,50)
        elseif x == 2 then
            self.Dx=math.random(-50,50)
            self.Dy=math.random(2)== 1 and 100 or -100
        end
    elseif game == 1 then  -- starts ball near who lost a point going it opp driection
        self.x= self.x -150
        self.Dx=math.random(75,100)
        self.Dy=math.random(-50,50)
    elseif game == 2 then
        self.x= self.x +150
        self.Dx=math.random(-100,-75)
        self.Dy=math.random(-50,50)
    elseif game == 4 then
        self.y= self.y -150
        self.Dy=math.random(75,100)
        self.Dx=math.random(-50,50)
    elseif game == 3 then
        self.y= self.y +150
        self.Dy=math.random(-100,-75)
        self.Dx=math.random(-50,50)
    end
end
function Ball:update(dt)
    self.y=self.y+self.Dy*dt
    self.x=self.x+self.Dx*dt
end
function Ball:render()
    love.graphics.rectangle("fill",self.x,self.y,4,4)
end

function Ball:collide(paddle)

    if self.x > paddle.x + paddle.w or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.h or paddle.y > self.y + self.height then
        return false
    end

    return true 
end
