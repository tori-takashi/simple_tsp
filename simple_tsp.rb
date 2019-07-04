points = []
current_generations = []
n = 300
generation_number = 8000
mutation_probability = 0.005 # 0.5%

def set_points(points)
  points.push({x: 4, y: 5})
  points.push({x: 7, y: 2})
  points.push({x: 9, y: 6})
  points.push({x: 2, y: 1})
  points.push({x: 8, y: 9})
  points.push({x: 1, y: 3})
  points.push({x: 14, y: 3})
  points.push({x: 32, y: 11})
  points.push({x: 19, y: 42})
  points.push({x: 87, y: 12})
  points.push({x: 28, y: 56})
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

def create_next_generation(current_generations, n, mutation_probability, points)
  next_generations = []
  denominator = calc_denominator(current_generations)
  crossing_genes_array = choose_crossing_genes(current_generations[0][:gene].size)

  #picking elites
  current_generations.sort_by! { |current_generation| current_generation[:solution] }
  elite = current_generations.take(20)
  next_generations.concat(elite)
  current_generations.shift(20)

  current_generations.each do |current_generation|
    roulette_probability_scaled = current_generation[:solution] / denominator.to_f * 10000
    mutation_probability_scaled = mutation_probability * 10000

    random = Random.new.rand * 10000  # consider at 0.01%

    if random < roulette_probability_scaled
      next_generations.push(current_generation)
    elsif roulette_probability_scaled <= random && random < roulette_probability_scaled + mutation_probability_scaled
      gene = generate_route_array(points).shuffle
      solution = calc_total_distance(points, gene)
      next_generations.push({solution: solution, gene: gene})
    else
      #[FIXME]
      crossed_gene = crossing_genes(current_generation, crossing_genes_array)
      solution = calc_total_distance(points, crossed_gene)
      next_generations.push({solution: solution, gene: crossed_gene})
    end
  end
  next_generations
end

def choose_crossing_genes(route_size)
  random = Random.new

  a = random.rand(route_size - 1).to_i
  b = random.rand(route_size - 1).to_i

  while a == b
    b = random.rand(route_size - 1)
  end
  [a, b]
end

def crossing_genes(current_generation, crossing_genes_array)
  gene = current_generation[:gene]
  t1 = gene[crossing_genes_array[0]]
  t2 = gene[crossing_genes_array[1]]

  manipulated_gene = gene
  manipulated_gene[crossing_genes_array[0]] = t2
  manipulated_gene[crossing_genes_array[1]] = t1

  manipulated_gene
end

def calc_denominator(current_generations)
  denominator = 0
  current_generations.each do |current_generation|
    puts current_generation
    denominator += current_generation[:solution]
  end
  denominator
end

set_points(points)
route = generate_route_array(points)
current_generations = create_first_generation(points, n)
generation_number.times do |i|
  current_generations = create_next_generation(current_generations, n, mutation_probability, points)
end

puts "最短距離:#{current_generations[0][:solution]}"
# [FIXME]squared value
route_output = ""
current_generations[0][:gene].each do |gene|
  route_output += "#{gene} -> "
end
puts "道順: #{route_output}"
