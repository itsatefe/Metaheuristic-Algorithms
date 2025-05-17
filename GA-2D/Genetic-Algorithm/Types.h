#ifndef TYPES_H
#define TYPES_H

enum SurvivalType
{
	elitism,
	generational
};
enum StopType {
	timeLimit,
	generation,
	convergence,
	evalCount,
	iteration
};

//struct Offsprings
//{
//	Chromosome offspring1;
//	Chromosome offspring2;
//};

struct Row {
	int width_used;
	int y_position;
	vector<Item> items;

	Row(int y) : width_used(0), y_position(y) {}
};

struct Event {
	int x;
	bool isLeft; // true if it's the left endpoint, false if it's the right endpoint
	const Item* rect;

	bool operator<(const Event& other) const {
		if (x != other.x)
			return x < other.x;
		if (isLeft != other.isLeft)
			return isLeft < other.isLeft;
		return rect->y < other.rect->y;
	}
};
//struct Event
//{
//	int x;
//	bool isLeft;
//	const Item* rect;
//
//	// Ensure proper sorting: by x coordinate, and placing 'enter' events before 'exit' events if coordinates are the same
//	bool operator<(const Event& other) const
//	{
//		if (x == other.x)
//			return isLeft && !other.isLeft;
//		return x < other.x;
//	}
//};


enum Direction
{
	NONE,
	TOP,
	RIGHT,
	BOTH,
	HORIZONTAL,
	VERTICAL
};
struct Overlap
{
	bool exists;
	Direction direction;
};
#endif
