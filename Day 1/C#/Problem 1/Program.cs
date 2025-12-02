using System.Diagnostics;
using System.Text.RegularExpressions;

class Problem1 {
	int TurnDial(int CurrentPosition, string Directions) {
		Match match = Regex.Match(Directions, @"([LR])(\d+)");
		if (!match.Success)
			throw new ArgumentException("Invalid direction format");

		string turnDirection = match.Groups[1].Value;
		int turnAmount = int.Parse(match.Groups[2].Value);
		Debug.WriteLine($"Direction: {turnDirection}");
		Debug.WriteLine($"Turn amount: {turnAmount}");

		int newPosition = (turnDirection == "R") ?
			CurrentPosition + turnAmount :
			CurrentPosition - turnAmount;
		Debug.WriteLine($"Initial new value: {newPosition}");

		while (newPosition < 0)
			newPosition += 100;

		int finalPosition = newPosition % 100;
		Debug.WriteLine($"Resolved new position: {finalPosition}");

		return finalPosition;
	}

	int SolveProblem1(string InputPath) {
		string[] inputData = File.ReadAllLines(InputPath);

		int dialPosition = 50;
		int answer = 0;

		foreach (string line in inputData) {
			Console.WriteLine($"Turning {line} from position {dialPosition}");
			dialPosition = TurnDial(dialPosition, line);
			if (dialPosition == 0) {
				Console.WriteLine("Adding 1 to answer");
				answer++;
			}
		}

		return answer;
	}

	static void Main(string[] args) {
		Problem1 problem = new Problem1();

		bool useDemo = args.Contains("--Demo");

		string inputFile = useDemo ? "DemoInputs.txt" : "RealInputs.txt";

		try {
			int result = problem.SolveProblem1(inputFile);
			Console.WriteLine($"Answer: {result}");
		} catch (Exception ex) {
			Console.WriteLine($"Error: {ex.Message}");
		}
	}
}
