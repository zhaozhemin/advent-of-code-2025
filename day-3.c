#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int findJoltage(char* battery) {
	char largest = '0';
	char secondLargest = '0';
	char ret[3];

	for (int i = 0; i < strlen(battery); i++) {
		if (battery[i] > largest) {

			if (i == strlen(battery) - 1) {
				secondLargest = battery[i];
			} else {
				largest = battery[i];
				secondLargest = battery[i + 1];
			}

		} else if (battery[i] > secondLargest) {
			secondLargest = battery[i];
		}
	}

	snprintf(ret, sizeof(ret), "%c%c", largest, secondLargest);

	return atoi(ret);
}

void compareAndReplace(char* battery, int number, int start) {
	for (int i = start; i < strlen(battery); i++) {
		if (number > battery[i]) {
			battery[i] = number;

			for (int j = i + 1; j < strlen(battery); j++) {
				battery[j] = '0';
			}

			break;
		}
	}
}

long long findJoltage2(char* battery) {
	char ret[] = "000000000000";
	int lastLegalFirstIndex = strlen(battery) - 12;

	for (int i = 0; i < strlen(battery); i++) {
		int start = 0;

		if (i > lastLegalFirstIndex) {
			start = i - lastLegalFirstIndex;
		}

		compareAndReplace(ret, battery[i], start);
	}

	return atoll(ret);
}

int main() {
	char line[1024];
	long long sum = 0;

	while (fgets(line, sizeof(line), stdin)) {
		line[strcspn(line, "\n")] = 0;
		sum += findJoltage2(line);
	}

	printf("%lld\n", sum);
	return 0;
}
