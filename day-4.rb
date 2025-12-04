def read_input
  layout = []

  File.foreach("./day-4-input") do |line|
    layout.push(line.chomp.chars)
  end

  layout
end

def get_pos(x, y)
  return {
    "tl": [x - 1, y - 1],
    "t": [x, y - 1],
    "tr": [x + 1, y - 1],
    "l": [x - 1, y],
    "r": [x + 1, y],
    "bl": [x - 1, y + 1],
    "b": [x, y + 1],
    "br": [x + 1, y + 1],
  }
end

def is_valid(layout, x, y)
  count = 0

  if layout[x][y] != "@"
    return false
  end

  get_pos(x, y).values.each do |x0, y0|
    if x0 < 0 or y0 < 0 or x0 > layout.length - 1 or y0 > layout[x0].length - 1
      next
    end

    if layout[x0][y0] == "@"
      count +=1
    end
  end

  return count < 4
end


def solve1(layout)
  count = 0
  coord = []
  layout.length.times do |i|
    layout[i].length.times do |j|
      if is_valid(layout, i, j)
        coord.push([i, j])
        count += 1
      end
    end
  end

  return [count, coord]
end

def solve2
  layout = read_input()
  count, coord = solve1(layout)
  total = count

  while count > 0
    coord.each do |x, y|
      layout[x][y] = "."
    end
    count, coord = solve1(layout)
    total += count
  end

  return total
end

puts solve2()
