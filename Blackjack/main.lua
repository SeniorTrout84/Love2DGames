function love.load()
  love.window.setTitle('Blackjack')
  
  --Initialize the deck
  deck = {}
  for suitIndex, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
    for rank = 1, 13 do
      print('suit: ' ..suit.. ', rank: ' .. rank)
      table.insert(deck, {suit = suit, rank = rank})
    end
  end
  
  print('Total number of cards in deck: ' ..#deck)
  
  --Draws a card for the respective player
  function takeCard(hand)
    table.insert(hand, table.remove(deck, love.math.random(#deck)))
  end
  
  --Players hand
  playerHand = {}
  takeCard(playerHand)
  takeCard(playerHand)

  
  --Dealers hand
  dealerHand = {}
  takeCard(dealerHand)
  takeCard(dealerHand)
  
  roundOver = false
  
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
end
  

function love.update(dt)

end

function love.draw()
  local output= {}
  
  table.insert(output, 'Player hand:')
  for cardIndex, card in ipairs(playerHand) do
    table.insert(output, 'suit: ' ..card.suit.. ', rank: ' ..card.rank)
  end
  
  table.insert(output, 'Total: ' ..getTotal(playerHand))
  table.insert(output, '')
  
  table.insert(output, 'Dealer hand:')
  for cardIndex, card in ipairs(dealerHand) do
    if not roundOver and cardIndex == 1 then
      table.insert(output, '(Card hidden)')
    else
      table.insert(output, 'suit: ' ..card.suit.. ', rank: ' ..card.rank)
    end
  end
  
  
  if roundOver then
    table.insert(output, 'Total: ' ..getTotal(dealerHand))
    table.insert(output, '')
    
    --Returns true if thisHand has won or false if it has lost
    local function hasHandWon(thisHand, otherHand)
      return getTotal(thisHand) <= 21 and (getTotal(otherHand) > 21 or getTotal(thisHand) > getTotal(otherHand))
    end
    
    --Checks if player has won
    if hasHandWon(playerHand, dealerHand) then
      table.insert(output, 'Player wins!')
    --Checks if dealer has won
    elseif hasHandWon(dealerHand, playerHand) then
      table.insert(output, 'Dealer wins!')
    else
      table.insert(output, 'Draw')
    end
  else
    table.insert(output, 'Total: ?')
  end
  
  
  love.graphics.print(table.concat(output, '\n'), 15, 15)
end

function love.keypressed(key)
  if not roundOver then
    if key == 'h' and not roundOver then
      takeCard(playerHand)
      if getTotal(playerHand) >= 21 then
        roundOver = true
      end
    elseif key == 's' then
      roundOver = true
    end
    
    if roundOver then
      while getTotal(dealerHand) < 17 do
        takeCard(dealerHand)
      end
    end
  else
    love.load()
  end
end