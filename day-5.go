package main

import (
	"fmt"
	"os"
	s "strings"
	"strconv"
	"cmp"
	"slices"
	"container/list"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Range struct {
	start int
	end int
}

func readInput() ([]Range, []int) {
	dat, err := os.ReadFile("./day-5-input")
	check(err)
	blocks := s.Split(string(dat), "\n\n")
	var ranges []Range

	for _, v := range s.Split(blocks[0], "\n") {
		r := s.Split(v, "-")
		start, err := strconv.Atoi(r[0])
		check(err)
		end, err := strconv.Atoi(r[1])
		check(err)
		ranges = append(ranges, Range{start: start, end: end})
	}

	var ids []int

	for _, v := range s.Split(blocks[1], "\n") {
		if (v == "") {
			continue
		}

		id, err := strconv.Atoi(v)
		check(err)
		ids = append(ids, id)
	}

	return ranges, ids
}

func isInRange(r Range, i int) bool {
	return i >= r.start && i <= r.end
}

func isInRangeArr(rs []Range, i int) bool {
	for _, v := range rs {
		if isInRange(v, i) {
			return true
		}
	}

	return false
}

func mergeRange(rs []Range) []Range {
	rangeCmp := func(a, b Range) int {
		r := cmp.Compare(a.start, b.start)

		if r == 0 {
			return cmp.Compare(a.end, b.end)
		}

		return r
	}

	slices.SortFunc(rs, rangeCmp)

	queue := list.New()

	for _, v := range rs[1:] {
		queue.PushBack(v)
	}

	result := []Range{rs[0]}

	for queue.Len() > 0 {
		elem := queue.Front()
		r := elem.Value.(Range)
		current := result[len(result) - 1]
		if (current.end < r.start) {
			result = append(result, r)
			queue.Remove(elem)
		} else if (current.end >= r.end) {
			queue.Remove(elem)
		} else if current.end < r.end {
			current.end = r.end
			result[len(result) - 1] = current
			queue.Remove(elem)
		}
	}

	return result
}

func main() {
	ranges, _ := readInput()
	ranges = mergeRange(ranges)
	count := 0

	for _, r := range ranges {
		count += (r.end - r. start) + 1
	}

	fmt.Println(count)
}
