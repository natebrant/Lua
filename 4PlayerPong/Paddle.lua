Paddle= Class{}


function Paddle:init(x,y,width,height)
    self.x=x
    self.y=y
    self.w=width
    self.h=height
    self.dy=0
    self.dx=0

end
-- paddle will update
function Paddle:update(dt)
    if self.dy<0 then
        -- see if we are at max then
        self.y=math.max(0,self.y+self.dy*dt)
    else    
        -- see if we are on bottom then
        self.y=math.min(VIRTUAL_HEIGHT-self.h,self.y+self.dy*dt)--down
    end    
end

function Paddle:update2(dt)
    if self.dx<0 then
        -- see if we are at max then
        self.x=math.max(0,self.x+self.dx*dt)
    else    
        -- see if we are on bottom then
        self.x=math.min(VIRTUAL_WIDTH-self.w,self.x+self.dx*dt)--down
    end    
end







--paddle draw or render
function Paddle:render()
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end

