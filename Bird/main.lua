love.window.setTitle('Bird')

playingAreaWidth = 300
playingAreaHeight = 388
jumpSound = love.audio.newSource("Jump3.wav", "static")
jumpSound:setVolume(0.20)
hitSound = love.audio.newSource("Hit_Hurt31.wav", "static")
scoreSound = love.audio.newSource("Pickup_Coin3.wav", "static")

love.window.setMode(playingAreaWidth, playingAreaHeight, 
  { vsync = off,
    fullscreen = off,
    resize = off
    })



function love.keypressed(key)
  if key == "space" then
    if birdY > 0 then
      birdYSpeed = -165
      jumpSound:play()
    end
  end
  
  if key == "escape" then
    love.event.quit()
  end
end

function love.load()
  birdX = 62
  birdWidth = 30
  birdHeight = 25
  
  pipeSpaceHeight = 100
  pipeWidth = 54
  
  highScore = 0
  
  function newPipeSpaceY()
    local pipeSpaceYMin = 54
    local pipeSpaceY = love.math.random(pipeSpaceYMin, playingAreaHeight - pipeSpaceHeight)
    return pipeSpaceY
  end
  
  function reset()
    birdY = 200
    birdYSpeed = 0
  
  
    pipe1X = playingAreaWidth
    pipe1SpaceY = newPipeSpaceY()
  
    pipe2X = playingAreaWidth + ((playingAreaWidth + pipeWidth) / 2)
    pipe2SpaceY = newPipeSpaceY()
  
    score = 0
    upcomingPipe = 1
  end
  reset()
end

function love.update(dt)
  birdYSpeed = birdYSpeed + (516 * dt)
  birdY = birdY + (birdYSpeed * dt)
  
  local function movePipe(pipeX, pipeSpaceY)
    
    pipeX = pipeX - (60 * dt)
  
    if  (pipeX + pipeWidth) < 0 then
      pipeX = playingAreaWidth
      pipeSpaceY = newPipeSpaceY()
    end
   
   return pipeX, pipeSpaceY
  end
  
  pipe1X, pipe1SpaceY = movePipe(pipe1X, pipe1SpaceY)
  pipe2X, pipe2SpaceY = movePipe(pipe2X, pipe2SpaceY)
  
  function isBirdCollidingWithPipe(pipeX, pipeSpaceY)
    return birdX < (pipeX + pipeWidth) and (birdX + birdWidth) > pipeX and (birdY < pipeSpaceY or (birdY+ birdHeight) > (pipeSpaceY + pipeSpaceHeight))
  end
  
  if isBirdCollidingWithPipe(pipe1X, pipe1SpaceY) or isBirdCollidingWithPipe(pipe2X, pipe2SpaceY) or birdY > playingAreaHeight then
    hitSound:play()
    if highScore < score then
      highScore = score
    end
    reset()
  end

  local function updateScoreAndClosestPipe(thisPipe, pipeX, otherPipe)
    if upcomingPipe == thisPipe and (birdX > (pipeX + pipeWidth)) then
      score = score + 1
      upcomingPipe = otherPipe
    end
  end
  
  updateScoreAndClosestPipe(1, pipe1X, 2)
  updateScoreAndClosestPipe(2, pipe2X, 1)
end

function love.draw()
  --Draw the background
  love.graphics.setColor(.14, .36, .46)
  love.graphics.rectangle('fill', 0, 0, playingAreaWidth, playingAreaHeight)
  
  --Draw the bird
  love.graphics.setColor(.87, .84, .27)
  love.graphics.rectangle('fill', birdX, birdY, birdWidth, birdHeight)
  
  --Draw the pipes
  local function drawPipe(pipeX, pipeSpaceY)
    love.graphics.setColor(.37, .82, .28)
    love.graphics.rectangle('fill', pipeX, 0, pipeWidth, pipeSpaceY)
    love.graphics.rectangle('fill',pipeX, pipeSpaceY + pipeSpaceHeight, pipeWidth, playingAreaHeight - pipeSpaceY - pipeSpaceHeight)
  end
  
  drawPipe(pipe1X, pipe1SpaceY)
  drawPipe(pipe2X, pipe2SpaceY)
  
  --Draw score
  love.graphics.setColor(1,1,1)
  printScore = "Score: " .. score
  love.graphics.print(printScore, 15, 15)
  
  --Draw hi-score
  printHighScore = "Hi-score: " .. highScore
  love.graphics.print(printHighScore, 15, 30)
end 