function love.load()
  love.window.setMode(800, 640, {vsync = false, fullscreen = false, resizable = false})
  love.window.setTitle('Blackjack')
  love.graphics.setBackgroundColor(220 / 255, 220 / 255, 220 / 255)
  shuffleSound = love.audio.newSource('shuffle.wav', 'static')
  drawSound = love.audio.newSource('draw.wav', 'static')
  
  --Draws a card for the respective player
  function takeCard(hand)
    table.insert(hand, table.remove(deck, love.math.random(#deck)))
    drawSound:play()
  end
  
  function getTotal(hand)
    local total = 0
    local hasAce = false
    
    for cardIndex, card in ipairs(hand) do
      if card.rank > 10 then
        total = total + 10
      else
        total = total + card.rank
      end
      
      if card.rank == 1 then
        hasAce = true
      end
      
      if hasAce and total<= 12 then
        total = total + 10
      end
    end
    
    return total
  end
  
  images = {}
  for nameIndex, name in ipairs({'cardClubsA', 'cardClubs2', 'cardClubs3', 'cardClubs4', 'cardClubs5', 'cardClubs6', 'cardClubs7', 'cardClubs8', 'cardClubs9', 'cardClubs10', 'cardClubsJ', 'cardClubsQ' ,'cardClubsK',
    'cardDiamondsA', 'cardDiamonds2', 'cardDiamonds3', 'cardDiamonds4', 'cardDiamonds5', 'cardDiamonds6', 'cardDiamonds7', 'cardDiamonds8', 'cardDiamonds9', 'cardDiamonds10', 'cardDiamondsJ', 'cardDiamondsQ', 'cardDiamondsK',
    'cardHeartsA', 'cardHearts2', 'cardHearts3', 'cardHearts4', 'cardHearts5', 'cardHearts6', 'cardHearts7', 'cardHearts8', 'cardHearts9', 'cardHearts10', 'cardHeartsJ', 'cardHeartsQ', 'cardHeartsK',
    'cardSpadesA', 'cardSpades2', 'cardSpades3', 'cardSpades4', 'cardSpades5', 'cardSpades6', 'cardSpades7', 'cardSpades8', 'cardSpades9', 'cardSpades10', 'cardSpadesJ', 'cardSpadesQ', 'cardSpadesK',
    'cardBack_green'}) do
    images[name] = love.graphics.newImage('Cards/' ..name.. '.png')
  end
  
  --Initialize fonts
  aceSansSmall = love.graphics.newFont('AceSans.otf', 16)
  aceSansBig = love.graphics.newFont('AceSans.otf', 24)
  
  CARD_WIDTH = 140
  
  BUTTON_HEIGHT = 35
  BUTTON_Y = 520
  
  HIT_BUTTON_X = 10
  HIT_BUTTON_WIDTH = 70
  
  STAND_BUTTON_X = 150
  STAND_BUTTON_WIDTH = 75
  
  PLAYAGAIN_BUTTON_X = 10
  PLAYAGAIN_BUTTON_WIDTH = 150
  
  function isMouseInButton(buttonX, buttonWidth)
    return love.mouse.getX() >= buttonX and love.mouse.getX() < buttonX + buttonWidth and love.mouse.getY() >= BUTTON_Y and love.mouse.getY() < BUTTON_Y + BUTTON_HEIGHT
  end
  
  function reset()
    deck = {}
    shuffleSound:play()
    for suitIndex, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
      for rank = 1, 13 do
        table.insert(deck, {suit = suit, rank = rank})
      end
    end
    love.timer.sleep(0.6)
    
    --Players hand
    playerHand = {}
    takeCard(playerHand)
    takeCard(playerHand)
    
    --Dealers hand
    dealerHand = {}
    takeCard(dealerHand)
    takeCard(dealerHand)
    
    roundOver = false
  end
  
  reset()
end

function love.update(dt)

end

function love.draw()
  local playerOutput = {}
  local dealerOutput = {}
  local winnerOutput = {}
  
  local function identifyCard(suit, rank)
    if suit == 'club' then
      if rank == 1 then
        return 'cardClubsA'
      elseif rank == 2 then
        return 'cardClubs2'
      elseif rank == 3 then
        return 'cardClubs3'
      elseif rank == 4 then
        return 'cardClubs4'
      elseif rank == 5 then
        return 'cardClubs5'
      elseif rank == 6 then
        return 'cardClubs6'
      elseif rank == 7 then
        return 'cardClubs7'
      elseif rank == 8 then
        return 'cardClubs8'
      elseif rank == 9 then
        return 'cardClubs9'
      elseif rank == 10 then
        return 'cardClubs10'
      elseif rank == 11 then
        return 'cardClubsJ'
      elseif rank == 12 then
        return 'cardClubsQ'
      elseif rank == 13 then
        return 'cardClubsK'
      end
    elseif suit == 'diamond' then
      if rank == 1 then
        return 'cardDiamondsA'
      elseif rank == 2 then
        return 'cardDiamonds2'
      elseif rank == 3 then
        return 'cardDiamonds3'
      elseif rank == 4 then
        return 'cardDiamonds4'
      elseif rank == 5 then
        return 'cardDiamonds5'
      elseif rank == 6 then
        return 'cardDiamonds6'
      elseif rank == 7 then
        return 'cardDiamonds7'
      elseif rank == 8 then
        return 'cardDiamonds8'
      elseif rank == 9 then
        return 'cardDiamonds9'
      elseif rank == 10 then
        return 'cardDiamonds10'
      elseif rank == 11 then
        return 'cardDiamondsJ'
      elseif rank == 12 then
        return 'cardDiamondsQ'
      elseif rank == 13 then
        return 'cardDiamondsK'
      end
    elseif suit == 'heart' then  
      if rank == 1 then
        return 'cardHeartsA'
      elseif rank == 2 then
        return 'cardHearts2'
      elseif rank == 3 then
        return 'cardHearts3'
      elseif rank == 4 then
        return 'cardHearts4'
      elseif rank == 5 then
        return 'cardHearts5'
      elseif rank == 6 then
        return 'cardHearts6'
      elseif rank == 7 then
        return 'cardHearts7'
      elseif rank == 8 then
        return 'cardHearts8'
      elseif rank == 9 then
        return 'cardHearts9'
      elseif rank == 10 then
        return 'cardHearts10'
      elseif rank == 11 then
        return 'cardHeartsJ'
      elseif rank == 12 then
        return 'cardHeartsQ'
      elseif rank == 13 then
        return 'cardHeartsK'
      end
    elseif suit == 'spade' then
      if rank == 1 then
        return 'cardSpadesA'
      elseif rank == 2 then
        return 'cardSpades2'
      elseif rank == 3 then
        return 'cardSpades3'
      elseif rank == 4 then
        return 'cardSpades4'
      elseif rank == 5 then
        return 'cardSpades5'
      elseif rank == 6 then
        return 'cardSpades6'
      elseif rank == 7 then
        return 'cardSpades7'
      elseif rank == 8 then
        return 'cardSpades8'
      elseif rank == 9 then
        return 'cardSpades9'
      elseif rank == 10 then
        return 'cardSpades10'
      elseif rank == 11 then
        return 'cardSpadesJ'
      elseif rank == 12 then
        return 'cardSpadesQ'
      elseif rank == 13 then
        return 'cardSpadesK'
      end
    end
  end
  
  local function drawCard(card, x, y)
    love.graphics.draw(images[card], x, y)
  end
  
  table.insert(playerOutput, 'Player hand:')
  for cardIndex, card in ipairs(playerHand) do
    drawCard(identifyCard(card.suit, card.rank), (cardIndex - 1) * CARD_WIDTH, 300)
  end
  
  table.insert(playerOutput, 'Total: ' ..getTotal(playerHand))
  table.insert(playerOutput, '')
  
  table.insert(dealerOutput, 'Dealer hand:')
  for cardIndex, card in ipairs(dealerHand) do
    if not roundOver and cardIndex == 1 then
      drawCard('cardBack_green', 0, 80)
    else
      drawCard(identifyCard(card.suit, card.rank), (cardIndex - 1) * CARD_WIDTH, 80)
    end
  end
  
  
  if roundOver then
    table.insert(dealerOutput, 'Total: ' ..getTotal(dealerHand))
    table.insert(dealerOutput, '')
    
    --Returns true if thisHand has won or false if it has lost
    local function hasHandWon(thisHand, otherHand)
      return getTotal(thisHand) <= 21 and (getTotal(otherHand) > 21 or getTotal(thisHand) > getTotal(otherHand))
    end
    
    --Checks if player has won
    if hasHandWon(playerHand, dealerHand) then
      table.insert(winnerOutput, 'Player wins!')
    --Checks if dealer has won
    elseif hasHandWon(dealerHand, playerHand) then
      table.insert(winnerOutput, 'Dealer wins!')
    else
      table.insert(winnerOutput, 'Draw')
    end
  else
    table.insert(dealerOutput, 'Total: ?')
  end
  
  --Set font and print text output
  love.graphics.setFont(aceSansSmall)
  love.graphics.setColor(0, 0, 0)
  
  love.graphics.print(table.concat(playerOutput, '\n'), 15, 15)
  love.graphics.print(table.concat(dealerOutput, '\n'), 365, 15)
  
  love.graphics.setColor(1, 0.6, 0.4)
  love.graphics.setFont(aceSansBig)
  love.graphics.print(table.concat(winnerOutput, '\n'), 630, 25)
  love.graphics.setColor(1, 1, 1)
  
  local function drawButton(text, buttonX, buttonWidth, textOffsetX)
    if love.mouse.getX() >= buttonX and love.mouse.getX() < buttonX + buttonWidth and love.mouse.getY() >= BUTTON_Y and love.mouse.getY() < BUTTON_Y + BUTTON_HEIGHT then
      love.graphics.setColor(1, 0.8, 0.3)
    else
      love.graphics.setColor(1, 0.5, 0.2)
    end
    
    love.graphics.rectangle('fill', buttonX, BUTTON_Y, buttonWidth, BUTTON_HEIGHT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(text, buttonX + textOffsetX, BUTTON_Y + 2)
  end
  
  if not roundOver then 
    --Draw hit button
    drawButton('Hit!', HIT_BUTTON_X, HIT_BUTTON_WIDTH, 15)
      
    --Draw stand button
    drawButton('Stand', STAND_BUTTON_X, STAND_BUTTON_WIDTH, 8)
  else
    --Draw play again button
    drawButton('Play again', PLAYAGAIN_BUTTON_X, PLAYAGAIN_BUTTON_WIDTH, 10)
  end
  
end

function love.mousereleased()
  if not roundOver then
    if isMouseInButton(HIT_BUTTON_X, HIT_BUTTON_WIDTH) then 
      takeCard(playerHand)
      if getTotal(playerHand) > 21 then
        roundOver = true
      end
    elseif isMouseInButton(STAND_BUTTON_X, STAND_BUTTON_WIDTH) then
      roundOver = true
    end
    
    if roundOver then
      while getTotal(dealerHand) < 17 do
        takeCard(dealerHand)
      end
      
    end
  elseif isMouseInButton(PLAYAGAIN_BUTTON_X, PLAYAGAIN_BUTTON_WIDTH) then
    reset()
  end
end
