points = []
current_generations = []
next_generations = []
n = 10

def set_points(points)
  points.push({x: 4, y: 5})
  points.push({x: 7, y: 2})
  points.push({x: 9, y: 6})
  points.push({x: 2, y: 1})
  points.push({x: 8, y: 9})
  points.push({x: 1, y: 3})
end

def calc_squared_distance(p1, p2)
  (p2[:x] - p1[:x]) ** 2 + (p2[:y] - p1[:y]) ** 2
end

def generate_route_array(points)
  route = []
  point_number = points.size

  point_number.times do |i|
    route.push(i)
  end
  route
end

def calc_total_distance(points, route)
  calc_time = points.size - 1
  total_distance = 0

  calc_time.times do |i|
    total_distance += calc_squared_distance(points[route[i]], points[route[i + 1]])
  end

  total_distance
end

def create_first_generation(points, n)
  current_generations = []
  route = generate_route_array(points)
  n.times do |i|
    gene = route.shuffle
    solution = calc_total_distance(points, gene)
    current_generations.push({solution: solution, gene: gene})
  end
  current_generations
end

def create_next_generation(n)
  # 1. ルーレット選択
  # 2. 一様公叉
  # 3. 突然変異
end

set_points(points)
route = generate_route_array(points)
puts create_first_generation(points, n)
