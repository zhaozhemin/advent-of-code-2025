function table_length(t)
   local count = 0
   for _ in pairs(t) do
      count = count + 1
   end
   return count
end

function print_table(t, indent)
    indent = indent or ""
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent .. k .. ":")
            print_table(v, indent .. "  ") -- Recursively print sub-tables
        else
            print(indent .. k .. ": " .. tostring(v))
        end
    end
end

function calc_distance(p1, p2)
   return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2 + (p1.z - p2.z) ^ 2)
end

function point_to_string(p)
   return p.x .. ',' .. p.y .. ',' .. p.z
end

function string_to_point(s)
   local tmp = {}

   for value in string.gmatch(s, "([^,]+)") do
      table.insert(tmp, tonumber(value))
   end

   local x, y, z = tmp[1], tmp[2], tmp[3]
   return {x = x, y = y, z = z}
end

function find_in_set(p)
   for i = 1, #set do
      if set[i][p] ~= nil then
         return i
      end
   end

   return nil
end

function merge_table(t1, t2)
   if #t1 > #t2 then
      for k, v in pairs(t2) do
         t1[k] = v
      end
      return 2
   else
      for k, v in pairs(t1) do
         t2[k] = v
      end
      return 1
   end
end

points = {}

for line in io.lines("./day-8-input") do
   table.insert(points, string_to_point(line))
end

distances = {}

for i = 1, #points do
   for j = 1, #points do
      if i ~= j then
         distances[calc_distance(points[i], points[j])] = {point_to_string(points[i]), point_to_string(points[j])}
      end
   end
end

sorted_dist = {}

for k, v in pairs(distances) do
   table.insert(sorted_dist, k)
end

table.sort(sorted_dist)

set = {}

for i = 1, #sorted_dist do
   local p1, p2 = distances[sorted_dist[i]][1], distances[sorted_dist[i]][2]
   local p1_set = find_in_set(p1)
   local p2_set = find_in_set(p2)

   if p1_set == nil and p2_set == nil then
      table.insert(set, {[p1] = true, [p2] = true})
   elseif p1_set == nil and p2_set ~= nil then
      set[p2_set][p1] = true
   elseif p1_set ~= nil and p2_set == nil then
      set[p1_set][p2] = true
   elseif p1_set ~= p2_set then
      local which = merge_table(set[p1_set], set[p2_set])
      if which == 1 then
         table.remove(set, p1_set)
      else
         table.remove(set, p2_set)
      end
   end

   if table_length(set) == 1 and table_length(set[1]) == 1000 then
      print("Problem 2: ", string_to_point(p1).x * string_to_point(p2).x)
      break
   end
end
